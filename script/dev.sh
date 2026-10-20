#!/bin/bash
set -e
# Usage: ./script/dev.sh [vX.Y.Z] — dev-only: kills the old build, builds Debug,
# runs from a fixed path so Accessibility / Screen Recording is granted only once.
# Pass a version to check for duplicates: ./script/dev.sh v0.11.12
cd "$(dirname "$0")/.."

VERSION_ARGS=()
if [ $# -ge 1 ]; then
    VERSION="${1#v}"
    if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "❌ Version '$1' must look like vX.Y.Z (e.g. ./script/dev.sh v0.11.12)"
        exit 1
    fi
    # Same as build.sh: 1117 + commit count so the build number keeps increasing.
    BUILD_NUMBER=$((1117 + $(git rev-list --count HEAD)))
    echo "→ Version override: $VERSION ($BUILD_NUMBER)"
    VERSION_ARGS=(MARKETING_VERSION="$VERSION" CURRENT_PROJECT_VERSION="$BUILD_NUMBER")
elif [ -n "${MARKETING_VERSION:-}" ] || [ -n "${CURRENT_PROJECT_VERSION:-}" ]; then
    [ -n "${MARKETING_VERSION:-}" ] && VERSION_ARGS+=(MARKETING_VERSION="$MARKETING_VERSION")
    [ -n "${CURRENT_PROJECT_VERSION:-}" ] && VERSION_ARGS+=(CURRENT_PROJECT_VERSION="$CURRENT_PROJECT_VERSION")
fi

# 只从可用的签名身份中选择，避免仅有证书却缺失私钥；默认不静默降级。
IDENTITY="${FLOE_CODE_SIGN_IDENTITY:-}"
if [ -z "$IDENTITY" ]; then
    IDENTITIES=$(security find-identity -v -p codesigning)
    IDENTITY=$(printf '%s\n' "$IDENTITIES" | awk '/"Floe Dev"/ { print $2; exit }')
    if [ -z "$IDENTITY" ]; then
        IDENTITY=$(printf '%s\n' "$IDENTITIES" | awk '/"Apple Development:/ { print $2; exit }')
    fi
    if [ -z "$IDENTITY" ]; then
        echo '❌ No usable development signing identity. Create a Code Signing certificate with its private key first.' >&2
        echo '   For a disposable build only: FLOE_CODE_SIGN_IDENTITY=- ./script/dev.sh' >&2
        exit 1
    fi
fi
DEV_APP="${FLOE_DEV_APP:-/Applications/Floe-Dev.app}"
DEST="platform=macOS,arch=arm64"

SIGN_ARGS=()
# ad-hoc 无 Team ID，关闭库验证所属的 hardened runtime，避免 Sparkle 启动失败。
if [ "$IDENTITY" = "-" ]; then
    echo "⚠️  Explicit ad-hoc build: rebuilding may invalidate existing permissions."
    SIGN_ARGS=(CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM= ENABLE_HARDENED_RUNTIME=NO)
else
    SIGN_ARGS=(CODE_SIGN_STYLE=Manual "CODE_SIGN_IDENTITY=$IDENTITY" "DEVELOPMENT_TEAM=${FLOE_DEVELOPMENT_TEAM:-}")
fi

echo "→ Building Debug (sign: ${IDENTITY})…"
xcodebuild -project Floe.xcodeproj -scheme Floe -configuration Debug \
    -destination "$DEST" "${SIGN_ARGS[@]}" "${VERSION_ARGS[@]}" build

APP_DIR=$(xcodebuild -project Floe.xcodeproj -scheme Floe -configuration Debug \
    -destination "$DEST" "${VERSION_ARGS[@]}" -showBuildSettings 2>/dev/null | sed -n 's/^ *BUILT_PRODUCTS_DIR *= *//p' | head -1)
SRC_APP="$APP_DIR/Floe.app"
[ -d "$SRC_APP" ] || { echo "❌ Not found: $SRC_APP"; exit 1; }

echo "→ Killing old build…"
pkill -x Floe 2>/dev/null || true
sleep 1

echo "→ Copying to $DEV_APP (fixed path = keeps permissions)…"
rm -rf "$DEV_APP"
ditto "$SRC_APP" "$DEV_APP"
echo "→ Re-signing uniformly ($IDENTITY, fixes dyld Team IDs)…"
codesign --force --deep --sign "$IDENTITY" "$DEV_APP"
codesign --verify --deep --strict "$DEV_APP"
echo "→ Current signature:"
codesign -dvvv "$DEV_APP" 2>&1 | grep -E "^(Authority|Identifier)" || true

BUILT_VERSION=$(defaults read "$DEV_APP/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "?")
BUILT_BUILD=$(defaults read "$DEV_APP/Contents/Info" CFBundleVersion 2>/dev/null || echo "?")
echo "→ Built version: $BUILT_VERSION ($BUILT_BUILD)"

# 同一路径覆盖安装时通知 Launch Services 重新读取资源，避免 Finder 沿用旧图标。
echo "→ Refreshing app registration and icon…"
touch "$DEV_APP"
LSREGISTER=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister
if [ -x "$LSREGISTER" ]; then
    "$LSREGISTER" -f "$DEV_APP"
fi

echo "→ Opening new build…"
open "$DEV_APP"
sleep 2
if FLOE_PID=$(pgrep -x Floe); then
    echo "✅ App is running (PID $FLOE_PID). Floe is a menu-bar app: look for its menu bar icon, it has no Dock icon."
    echo "   Live logs: log stream --predicate 'process == \"Floe\"' --level debug"
else
    echo "❌ App launched then quit — newest crash log: ls -t ~/Library/Logs/DiagnosticReports/Floe-*.ips | head -1"
    exit 1
fi

echo ""
echo "✅ Done. Grant in System Settings; keep using the same certificate and app path:"
echo "   • Accessibility: open \"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility\""
echo "   • Screen Recording: open \"x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture\""
