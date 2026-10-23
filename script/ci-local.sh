#!/bin/bash
# Mirror of .github/workflows/lint.yml + release.yml — run before push/tag.
# Usage: ./script/ci-local.sh [vX.Y.Z]  (pass tag to also validate tag format)
set -euo pipefail
cd "$(dirname "$0")/.."
source ./script/lib/build-settings.sh
floe_resolve_build_settings "${1:-}"
if [ -n "${1:-}" ]; then
  floe_validate_release_tag "$1"
fi

if ! command -v swiftlint >/dev/null; then
  echo "swiftlint not found — run: brew install swiftlint"
  exit 1
fi
# Keep in sync with .github/workflows/lint.yml (SWIFTLINT_VERSION).
if [ "$(swiftlint version)" != "0.65.1" ]; then
  echo "warning: local swiftlint $(swiftlint version) != CI 0.65.1 — run: brew upgrade swiftlint"
fi
echo "==> swiftlint --strict"
swiftlint --strict
echo "==> release pipeline regression checks"
python3 script/tests/release-pipeline.py

echo "==> xcodebuild -version (CI builds with Xcode 26.6 on macos-26)"
xcodebuild -version
XCODE_MAJOR=$(xcodebuild -version | head -1 | awk '{print $2}' | cut -d. -f1)
if [ "${XCODE_MAJOR:-0}" -lt 26 ]; then
  echo "warning: Xcode $XCODE_MAJOR < 26 links the legacy appearance; CI uses Xcode 26.6 (Liquid Glass SDK)"
fi

echo "==> Shared Universal packaging and artifact checks"
# 预检使用独立输出目录，既不覆盖正式包，也可重复执行。
if [ -z "${FLOE_RELEASE_ROOT:-}" ]; then
  mkdir -p release
  FLOE_RELEASE_ROOT=$(mktemp -d "$PWD/release/preflight.XXXXXX")
  export FLOE_RELEASE_ROOT
fi
export FLOE_DERIVED_DATA_PATH="${FLOE_DERIVED_DATA_PATH:-$PWD/release/.derived-data}"
./script/build.sh "${1:-}"

echo "ci-local PASS"
