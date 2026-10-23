#!/bin/bash
# Tag + push to trigger the shared ZIP/DMG packaging workflow.
# Usage: ./script/release.sh vX.Y.Z   (e.g. ./script/release.sh v0.11.13)
# Automatic updates stay disabled until Floe owns its feed and signing key.
set -euo pipefail
cd "$(dirname "$0")/.."
source ./script/lib/build-settings.sh

TAG="${1:-}"
if ! [[ "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "usage: $0 vX.Y.Z   (e.g. $0 v0.11.13)"
  exit 1
fi
if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "tag '$TAG' already exists"
  exit 1
fi
if [ -n "$(git status --porcelain)" ]; then
  echo "working tree dirty — commit or stash first"
  exit 1
fi

floe_validate_release_tag "$TAG"
./script/ci-local.sh "$TAG"

git tag "$TAG"
git push origin "$TAG"
echo "pushed $TAG — watch CI for verified Floe.zip, Floe.dmg, SHA256SUMS.txt and build-info.json"
