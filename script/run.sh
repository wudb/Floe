#!/bin/bash
set -e
# 开发入口共用稳定签名和安装路径，避免 run/dev 两套构建交替使授权失配。
exec "$(dirname "$0")/dev.sh" "$@"
