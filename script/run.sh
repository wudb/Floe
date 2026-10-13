#!/bin/bash
set -e
# Usage: ./script/run.sh — build Debug and launch locally.
cd "$(dirname "$0")/.."
# 本地 ad-hoc 没有 Team ID；关闭 hardened runtime，避免 Sparkle 库验证失败。
SIGN_ARGS='CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY=- DEVELOPMENT_TEAM= ENABLE_HARDENED_RUNTIME=NO'
xcodebuild -project Floe.xcodeproj -scheme Floe -configuration Debug -destination "platform=macOS,arch=arm64" $SIGN_ARGS build
APP_DIR=$(xcodebuild -project Floe.xcodeproj -scheme Floe -configuration Debug -destination "platform=macOS,arch=arm64" -showBuildSettings 2>/dev/null | grep -m 1 "BUILT_PRODUCTS_DIR" | awk '{print $3}')
pkill -x Floe 2>/dev/null || true
open "$APP_DIR/Floe.app"
