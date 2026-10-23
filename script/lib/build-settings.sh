#!/bin/bash
# 开发、打包及 CI 共用版本来源；不再根据提交数或 CI 运行次数推算构建号。

FLOE_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

floe_project_setting() {
    local values
    values=$(awk -v key="$1" '$1 == key && $2 == "=" { gsub(/[";]/, "", $3); print $3 }' \
        "$FLOE_PROJECT_DIR/Floe.xcodeproj/project.pbxproj" | sort -u)
    if [ -z "$values" ] || [[ "$values" == *$'\n'* ]]; then
        echo "Missing or inconsistent project setting: $1" >&2
        return 1
    fi
    printf '%s\n' "$values"
}

floe_resolve_build_settings() {
    local requested="${1:-}" project_version project_build
    project_version=$(floe_project_setting MARKETING_VERSION) || return 1
    project_build=$(floe_project_setting CURRENT_PROJECT_VERSION) || return 1
    FLOE_BUNDLE_ID=$(floe_project_setting PRODUCT_BUNDLE_IDENTIFIER) || return 1
    FLOE_VERSION="${MARKETING_VERSION:-$project_version}"
    if [ -n "$requested" ]; then
        requested="${requested#v}"
        if [ -n "${MARKETING_VERSION:-}" ] && [ "$MARKETING_VERSION" != "$requested" ]; then
            echo "Tag and MARKETING_VERSION disagree" >&2
            return 1
        fi
        FLOE_VERSION="$requested"
    fi
    FLOE_BUILD_NUMBER="${CURRENT_PROJECT_VERSION:-$project_build}"
    if ! [[ "$FLOE_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || \
       ! [[ "$FLOE_BUILD_NUMBER" =~ ^[1-9][0-9]{0,8}$ ]] || \
       ! [[ "$project_build" =~ ^[1-9][0-9]{0,8}$ ]]; then
        echo "Expected version X.Y.Z and a positive build number (up to 9 digits)" >&2
        return 1
    fi
    if [ "$FLOE_BUILD_NUMBER" -lt "$project_build" ]; then
        echo "Build number cannot be lower than the committed project build ($project_build)" >&2
        return 1
    fi
    if [ "$FLOE_BUNDLE_ID" != "com.float.floe" ]; then
        echo "Unexpected Floe bundle identifier: $FLOE_BUNDLE_ID" >&2
        return 1
    fi
    VERSION_ARGS=("MARKETING_VERSION=$FLOE_VERSION" "CURRENT_PROJECT_VERSION=$FLOE_BUILD_NUMBER")
}

floe_validate_release_tag() {
    local tag="${1:-}" project_version project_build previous previous_build
    [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "Expected release tag vX.Y.Z" >&2; return 1; }
    floe_resolve_build_settings "$tag" || return 1
    project_version=$(floe_project_setting MARKETING_VERSION) || return 1
    project_build=$(floe_project_setting CURRENT_PROJECT_VERSION) || return 1
    if [ "${tag#v}" != "$project_version" ] || [ "$FLOE_BUILD_NUMBER" != "$project_build" ]; then
        echo "Commit the release version and build number in the Xcode project before tagging" >&2
        return 1
    fi
    if [ "$(git -C "$FLOE_PROJECT_DIR" rev-parse --is-shallow-repository)" = true ]; then
        echo "Release validation requires full Git history and tags (fetch-depth: 0)" >&2
        return 1
    fi
    # 只比较当前分支可达的正式版本；旧 tag 重建也按其前一版本检查。
    previous=$(git -C "$FLOE_PROJECT_DIR" tag --merged HEAD --list 'v*' | \
        awk -v current="$tag" '/^v[0-9]+\.[0-9]+\.[0-9]+$/ && $0 != current { print }' | \
        { cat; printf '%s\n' "$tag"; } | sort -V | \
        awk -v current="$tag" '$0 == current { previous=last } { last=$0 } END { print previous }')
    if [ -n "$previous" ]; then
        previous_build=$(git -C "$FLOE_PROJECT_DIR" show "$previous:Floe.xcodeproj/project.pbxproj" | \
            awk '$1 == "CURRENT_PROJECT_VERSION" && !seen { gsub(/;/, "", $3); print $3; seen=1 }') || return 1
        if ! [[ "$previous_build" =~ ^[1-9][0-9]{0,8}$ ]] || [ "$project_build" -le "$previous_build" ]; then
            echo "Release build must be greater than $previous ($previous_build)" >&2
            return 1
        fi
    fi
}
