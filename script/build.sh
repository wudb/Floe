#!/bin/bash
# 本地和 GitHub Actions 共用的 Universal 打包入口；不会发布或启动应用。
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/build-settings.sh"
[ "$#" -le 1 ] || { echo "Usage: $0 [vX.Y.Z]" >&2; exit 1; }
floe_resolve_build_settings "${1:-}"
if [ -n "${FLOE_RELEASE_TAG:-}" ]; then
    floe_validate_release_tag "$FLOE_RELEASE_TAG"
fi

RELEASE_ROOT="${FLOE_RELEASE_ROOT:-$FLOE_PROJECT_DIR/release}"
mkdir -p "$RELEASE_ROOT"
RELEASE_ROOT="$(cd "$RELEASE_ROOT" && pwd)"
OUTPUT_DIR="$RELEASE_ROOT/v$FLOE_VERSION"
if [ -e "$OUTPUT_DIR" ] || [ -L "$OUTPUT_DIR" ]; then
    echo "Output already exists: $OUTPUT_DIR" >&2
    echo "Use a different FLOE_RELEASE_ROOT to rebuild without replacing previous artifacts." >&2
    exit 1
fi
# 失败仅清理本次临时目录；保留旧版本、构建日志和共享编译缓存。
STAGING_DIR="$(mktemp -d "$RELEASE_ROOT/.v$FLOE_VERSION.XXXXXX")"
cleanup() {
    local status=$?
    if [ "$status" -ne 0 ] && [ -f "$STAGING_DIR/build.log" ]; then
        cp "$STAGING_DIR/build.log" "$RELEASE_ROOT/failed-build-$(basename "$STAGING_DIR").log"
    fi
    rm -rf "$STAGING_DIR"
}
trap cleanup EXIT
DERIVED_DATA="${FLOE_DERIVED_DATA_PATH:-$RELEASE_ROOT/.derived-data}"
BUILD_ARGS=(-project "$FLOE_PROJECT_DIR/Floe.xcodeproj" -scheme Floe -configuration Release
    -destination 'generic/platform=macOS' -derivedDataPath "$DERIVED_DATA"
    'ARCHS=arm64 x86_64' ONLY_ACTIVE_ARCH=NO
    CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM= ENABLE_HARDENED_RUNTIME=NO
    "${VERSION_ARGS[@]}")
if [ -n "${FLOE_SOURCE_PACKAGES_PATH:-}" ]; then
    BUILD_ARGS+=(-clonedSourcePackagesDirPath "$FLOE_SOURCE_PACKAGES_PATH")
fi
echo "Building Floe $FLOE_VERSION ($FLOE_BUILD_NUMBER), Universal, ad-hoc"
xcodebuild "${BUILD_ARGS[@]}" build 2>&1 | tee "$STAGING_DIR/build.log"
ditto "$DERIVED_DATA/Build/Products/Release/Floe.app" "$STAGING_DIR/Floe.app"
# ad-hoc 没有 Team ID；保持与当前发行版相同的 Sparkle 库验证策略。
codesign --force --deep --sign - "$STAGING_DIR/Floe.app"
codesign --verify --deep --strict "$STAGING_DIR/Floe.app"
ditto -c -k --sequesterRsrc --keepParent "$STAGING_DIR/Floe.app" "$STAGING_DIR/Floe.zip"
mkdir "$STAGING_DIR/dmg"
ditto "$STAGING_DIR/Floe.app" "$STAGING_DIR/dmg/Floe.app"
ln -s /Applications "$STAGING_DIR/dmg/Applications"
hdiutil create -volname Floe -srcfolder "$STAGING_DIR/dmg" -format UDZO "$STAGING_DIR/Floe.dmg"
rm -rf "$STAGING_DIR/dmg"
python3 "$SCRIPT_DIR/verify-release.py" "$STAGING_DIR" "$FLOE_VERSION" "$FLOE_BUILD_NUMBER" "$FLOE_BUNDLE_ID"
# 所有检查通过后才暴露最终目录；同一版本的并发构建不能覆盖彼此产物。
python3 - "$STAGING_DIR" "$OUTPUT_DIR" <<'PY'
import os
import sys
if os.path.lexists(sys.argv[2]):
    raise SystemExit("Output appeared during build; refusing to replace it")
os.rename(sys.argv[1], sys.argv[2])
PY
echo "Verified release artifacts: $OUTPUT_DIR"
