#!/bin/bash
# 只读采集复现环境；不启动 Floe、不请求隐私权限、不修改系统设置。
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_PATH="${1:-}"
EVIDENCE_DIR="$(mktemp -d "${TMPDIR:-/tmp/}Floe-evidence.XXXXXX")"

# 每项采集独立保留退出码，缺失工具或未安装应用不会伪装成成功。
capture() {
    local name="$1"
    shift
    local status=0
    "$@" > "$EVIDENCE_DIR/$name.txt" 2>&1 || status=$?
    printf '%s\t%s\n' "$name" "$status" >> "$EVIDENCE_DIR/exit-status.tsv"
}

cd "$PROJECT_DIR"
capture system sw_vers
capture architecture uname -m
capture xcode xcodebuild -version
capture revision git rev-parse HEAD
capture worktree git status --short
capture packages cat Floe.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved
capture lint-version swiftlint version
# 仅列出本项目进程，不采集其他应用的命令行或系统硬件序列号。
capture process pgrep -x Floe
capture preferences defaults export com.wudb.Floe -

if [ -n "$APP_PATH" ]; then
    if [ ! -d "$APP_PATH/Contents" ]; then
        printf 'Invalid app path: %s\n' "$APP_PATH" >&2
        exit 1
    fi
    capture app-info plutil -p "$APP_PATH/Contents/Info.plist"
    capture signature codesign -d --verbose=4 "$APP_PATH"
    capture signature-check codesign --verify --deep --strict "$APP_PATH"
fi

cp "$PROJECT_DIR/docs/issue-reproduction-template.md" "$EVIDENCE_DIR/reproduction.md"
TZ=Asia/Shanghai date '+%Y-%m-%dT%H:%M:%S%z' > "$EVIDENCE_DIR/captured-at.txt"
printf 'Evidence: %s\n' "$EVIDENCE_DIR"
printf 'Fill reproduction.md; nonzero exit codes are recorded in exit-status.tsv.\n'
