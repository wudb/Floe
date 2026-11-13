#!/bin/bash
# 从 GitHub Release 的 Floe.zip 生成签名更新清单，验证后上传到同一 Release。
# Usage: SPARKLE_BIN=/path/to/Sparkle/bin ./script/update-appcast.sh vX.Y.Z --publish
# Options: --account <keychain-account>, --key <EdDSA-key-file>, --bootstrap, --publish
# 默认使用 com.float.floe 钥匙串账户；私钥文件也可通过 SPARKLE_PRIVATE_KEY 指定。
# --bootstrap 仅用于给尚未接入更新器的旧安装包建立初始更新源。
set -euo pipefail
cd "$(dirname "$0")/.."

TAG=""
ACCOUNT="${SPARKLE_ACCOUNT:-com.float.floe}"
KEY="${SPARKLE_PRIVATE_KEY:-}"
BOOTSTRAP=false
PUBLISH=false
while [ "$#" -gt 0 ]; do
    case "$1" in
        --account|--key)
            [ "$#" -ge 2 ] && [ -n "$2" ] || { echo "Missing value for $1" >&2; exit 1; }
            if [ "$1" = --account ]; then
                ACCOUNT="$2"
            else
                KEY="$2"
            fi
            shift 2
            ;;
        --bootstrap) BOOTSTRAP=true; shift ;;
        --publish) PUBLISH=true; shift ;;
        -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
        v*)
            [ -z "$TAG" ] || { echo "Only one release tag is allowed" >&2; exit 1; }
            TAG="$1"
            shift
            ;;
        *) echo "Unknown argument: $1" >&2; exit 1 ;;
    esac
done
if ! [[ "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Usage: $0 vX.Y.Z [--account <account>] [--key <EdDSA-key-file>] [--bootstrap] [--publish]" >&2
    exit 1
fi
command -v gh >/dev/null || { echo "Missing gh" >&2; exit 1; }
SPARKLE_BIN="${SPARKLE_BIN:-}"
if [ -z "$SPARKLE_BIN" ]; then
    GENERATOR="$(command -v generate_appcast || true)"
    [ -n "$GENERATOR" ] || { echo "Set SPARKLE_BIN to Sparkle's bin directory" >&2; exit 1; }
    SPARKLE_BIN="$(dirname "$GENERATOR")"
fi
for tool in generate_appcast sign_update; do
    [ -x "$SPARKLE_BIN/$tool" ] || { echo "Missing executable: $SPARKLE_BIN/$tool" >&2; exit 1; }
done
SIGNING_ARGS=(--account "$ACCOUNT")
if [ -n "$KEY" ]; then
    [ -f "$KEY" ] || { echo "Private key file not found" >&2; exit 1; }
    SIGNING_ARGS=(--ed-key-file "$KEY")
fi

WORK="$(mktemp -d "${TMPDIR:-/tmp}/Floe-appcast.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT
PREFIX="https://github.com/wudb/Floe/releases/download/$TAG/"
gh release view "$TAG" -R wudb/Floe --json tagName,isDraft,isPrerelease,publishedAt,assets,body > "$WORK/release.json"
gh release download "$TAG" -R wudb/Floe -p Floe.zip -D "$WORK"
unzip -p "$WORK/Floe.zip" Floe.app/Contents/Info.plist > "$WORK/archive.plist"
python3 - "$WORK/release.json" "$WORK/Floe.md" <<'PY'
import json
from pathlib import Path
import sys
metadata = json.loads(Path(sys.argv[1]).read_text())
Path(sys.argv[2]).write_text(metadata.get("body") or "")
PY

# 全量 ZIP 的下载地址固定到版本，避免 latest 切换后签名与内容不一致。
"$SPARKLE_BIN/generate_appcast" "${SIGNING_ARGS[@]}" --maximum-deltas 0 --embed-release-notes \
    --link "https://github.com/wudb/Floe/releases/tag/$TAG" \
    --download-url-prefix "$PREFIX" "$WORK"

# 旧安装包没有 SUPublicEDKey 时，generate_appcast 不会写入签名。
# 单独签名原 ZIP，并由下面的公钥校验确认其来源。
SIGNATURE="$(python3 - "$WORK/appcast.xml" <<'PY'
import sys
import xml.etree.ElementTree as ET
root = ET.parse(sys.argv[1])
enclosure = root.find("./channel/item/enclosure")
if enclosure is None:
    raise SystemExit("Generated appcast has no enclosure")
print(enclosure.get("{http://www.andymatuschak.org/xml-namespaces/sparkle}edSignature", ""))
PY
)"
if [ -z "$SIGNATURE" ]; then
    SIGNATURE="$("$SPARKLE_BIN/sign_update" "${SIGNING_ARGS[@]}" -p "$WORK/Floe.zip")"
fi
# 已发布版本使用 GitHub 发布时刻，保证重跑时清单中的日期一致。
python3 - "$WORK/appcast.xml" "$WORK/release.json" "$SIGNATURE" <<'PY'
from datetime import datetime
from email.utils import format_datetime
import json
import sys
import xml.etree.ElementTree as ET

path, metadata_path, signature = sys.argv[1:]
namespace = "http://www.andymatuschak.org/xml-namespaces/sparkle"
ET.register_namespace("sparkle", namespace)
tree = ET.parse(path)
item = tree.find("./channel/item")
item.find("enclosure").set(f"{{{namespace}}}edSignature", signature)
with open(metadata_path) as stream:
    published_at = json.load(stream)["publishedAt"]
if published_at:
    item.find("pubDate").text = format_datetime(datetime.fromisoformat(published_at.replace("Z", "+00:00")))
tree.write(path, encoding="utf-8", xml_declaration=True)
PY

# 上传前同时验证发布元数据、应用身份、版本以及公钥签名。
swift script/verify-appcast.swift "$WORK/appcast.xml" "$WORK/Floe.zip" \
    "$WORK/archive.plist" Floe/Info.plist "$WORK/release.json" "$TAG" "$BOOTSTRAP"
gh release upload "$TAG" "$WORK/appcast.xml" -R wudb/Floe --clobber
mkdir "$WORK/remote"
gh release download "$TAG" -R wudb/Floe -p appcast.xml -D "$WORK/remote"
cmp "$WORK/appcast.xml" "$WORK/remote/appcast.xml"
echo "Verified appcast uploaded: ${PREFIX}appcast.xml"
if [ "$PUBLISH" = true ]; then
    # 更新清单齐全后才发布并切换 latest，避免客户端读到缺少清单的新版本。
    gh release view -R wudb/Floe --json tagName > "$WORK/latest.json"
    python3 - "$TAG" "$WORK/latest.json" <<'PY'
import json
from pathlib import Path
import sys
latest = json.loads(Path(sys.argv[2]).read_text())["tagName"]
def version(tag):
    return tuple(int(part) for part in tag.removeprefix("v").split("."))
if version(sys.argv[1]) < version(latest):
    raise SystemExit("Refusing to promote a release older than the current latest")
PY
    gh release edit "$TAG" -R wudb/Floe --draft=false --latest
    curl --fail --silent --show-error --location --retry 3 --connect-timeout 15 --max-time 90 \
        https://github.com/wudb/Floe/releases/latest/download/appcast.xml -o "$WORK/public-appcast.xml"
    cmp "$WORK/appcast.xml" "$WORK/public-appcast.xml"
    echo "Published and verified latest release: $TAG"
fi
echo "Update feed: https://github.com/wudb/Floe/releases/latest/download/appcast.xml"
