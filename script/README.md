# Scripts

Local dev and release helpers. Run from the repository root.

## Local development

```bash
# Build Debug and launch the app
./script/run.sh

# Build Release DMG into release/ (optional version override for About)
./script/build.sh [vX.Y.Z]

# Same lint + build as CI — run before pushing (optional tag check)
./script/ci-local.sh [vX.Y.Z]
```

Install SwiftLint first if needed: `brew install swiftlint`.

## Issue evidence baseline

```bash
bash script/collect-issue-evidence.sh [/absolute/path/Floe.app]
```

Creates a unique temporary evidence directory with environment, revision,
locked dependencies, Floe preferences and optional app signature checks.
Each collector records its exit code, including unavailable tools. It does not
launch Floe or change permissions/settings. Fill in `reproduction.md` with the
actual steps, display setup, permission behavior and observed CGS/AX path.
Review preferences before sharing. See [M0 audit](../docs/m0-issue-audit.md).

Development entry points `run.sh` and `dev.sh` share a fixed install path,
`/Applications/Floe-Dev.app`. They choose a usable `Floe Dev` signing identity,
then an Apple Development identity. Set `FLOE_CODE_SIGN_IDENTITY` to pin a
specific certificate if multiple identities exist. Missing identities fail
instead of silently producing an ad-hoc build. Explicit disposable builds can
use `FLOE_CODE_SIGN_IDENTITY=- ./script/dev.sh`; their grants may expire after
rebuilding.

For Xcode Run, select your development Team in Signing & Capabilities. Debug
uses Apple Development signing; keep the same certificate and launch path.
Changing from an old ad-hoc build may require granting Accessibility and Screen
Recording again, then restarting the app. The scripts do not reset TCC grants.
Release signing remains unchanged. Ad-hoc Release builds need
`ENABLE_HARDENED_RUNTIME=NO` for the embedded Sparkle framework.

## Language regression checks

```bash
swift script/tests/app-language.swift
```

Covers system-language matching, fallback to English, saved selections, native
menu localization and formatted messages without changing system preferences.

## M1 stability regression checks

```bash
swift script/tests/screen-capture-executor.swift
swift script/tests/image-cache-retention.swift
swift script/tests/window-id.swift
swift script/tests/menu-interaction-safety.swift
```

Runs the production capture executor and extracted production cache/window ID
methods with controlled inputs. Covers blocked captures, deadlines, late
completion, concurrent-trigger rejection, stale-image release and integer
overflow. Does not capture the screen, request privacy permissions or replace
long-duration WindowServer measurements. See [M1 audit](../docs/m1-issue-audit.md).

The C0 menu safety check compiles the production menu guard and activation/length
methods against controlled services. Discovery and AX activation checks also
cover reentrant scans and foreign-popup rehide protection. See [C0 audit](../docs/c0-issue-audit.md).

## Menu bar AX thread regression checks

```bash
swift script/tests/menu-bar-ax-probe.swift
```

Compiles the production probe with a controlled AX service. Checks that both
main-thread and background callers perform hit testing and attribute reads on
the main thread, return value snapshots, and finish without deadlocking.

## Floe Bar regression checks

```bash
swift script/tests/item-discovery.swift
swift script/tests/floe-bar-position.swift
swift script/tests/ax-item-press.swift
swift script/tests/ax-activation.swift
```

These checks compile and execute the cache/positioning methods from the current
source with controlled WindowServer and screen inputs. They cover missing
dividers, retries with unchanged window IDs, and positioning without a window
ID. They need Xcode's Swift toolchain, but no privacy grants or running Floe app.
They do not replace testing Accessibility discovery and icon clicks in the app.

The AX check executes the discovery and press implementation against an in-memory
Accessibility tree. It verifies selection for anonymous or identically named
siblings, changing titles, stale elements, and denied permission without clicking
the real menu bar.

The activation check runs the Floe Bar click handler and temporary-reveal lifecycle
against a controlled menu server: originals must be shown before pressing, menus
must remain visible until closed, and cleanup must preserve newer user choices.
It also executes the section's hide/start/stop-rehide methods to check compact
popups, submenu dismissal, automatic rehide suppression and restart after a fired
timer, and explicit hiding while activation is in progress.

## After installing a build

```bash
# Clear stale TCC entries so Accessibility / Screen Recording can be re-granted
./script/fix-permissions.sh [/path/to/Floe.app]
```

Ad-hoc signed builds are pinned to a `cdhash` that changes with every build, so the grant recorded for the previous binary stops matching — System Settings shows the toggle on while the app is denied. See [Permissions](../README.md#permissions).

## Release

```bash
# Build and publish the GitHub Release through CI
./script/release.sh vX.Y.Z
```

CI publishes `Floe.zip` to this repository. Homebrew publishing is optional:
configure `FLOE_HOMEBREW_TAP` as a repository variable and
`HOMEBREW_TAP_TOKEN` as a secret only after a Floe tap exists.

## Automatic updates

Floe does not use the upstream Ice appcast or public key. Automatic updates are
currently disabled. Before enabling them:

1. Create and host Floe's own appcast repository; configure its Git URL through
   `FLOE_RELEASES_REPO` or `--releases-repo`.
2. Configure `SUFeedURL` and Floe's `SUPublicEDKey` in `Floe/Info.plist`, and enable
   `SUEnableAutomaticChecks` if automatic checks should be on by default.
3. Keep the matching Sparkle private key outside Git, or use the Keychain.
4. Publish the appcast after each GitHub Release:

```bash
./script/update-appcast.sh vX.Y.Z --releases-repo <git-url> --key <private-key.pem>
```

This downloads `Floe.zip` from `wudb/Floe`; verify the configured `SUFeedURL`
contains the new tag. The script requires `gh` and Sparkle's `generate_appcast`.

Tags must follow `vX.Y.Z` and increase with each release. Never re-tag an old
version. CI injects the version into the Xcode build.

## Adaptive presentation regression checks

```bash
swift script/tests/adaptive-presentation.swift
swift script/tests/adaptive-presentation-integration.swift
swift script/tests/adaptive-menu-measurement.swift
swift script/tests/display-space-states.swift
```

Compiles production policy, preferences, controller and Space parsing against
controlled display/menu snapshots. Covers section/display/fullscreen priority,
combined display scopes, missing measurements, notch capacity, hysteresis,
pointer targeting, deferred cleanup and reconnect persistence. These checks do
not manipulate real menu items or replace mixed desktop/fullscreen, hotplug and
notched MacBook acceptance. See [M5 third-batch status](../docs/m5-c-status.json).

## Layout icon merge and native movement

```bash
swift script/tests/layout-cache-fallback.swift
swift script/tests/layout-native-move.swift
swift script/tests/layout-drag-reveal.swift
swift script/tests/layout-refresh-state.swift
```

Compiles production merge and movement methods with controlled services. Checks
inset AX geometry, separate same-name icons, native divider insertion for empty
groups, stale-owner rejection and on-screen AX fallback. Real third-party icon
movement remains a separate acceptance step; see the [layout fix](../docs/layout-icon-merge-fix.md).

Layout click routing and readback checks:

```bash
swift script/tests/control-item-click.swift
swift script/tests/ax-row-filter.swift
swift script/tests/layout-cache-fallback.swift
```

Checks normal versus Option-click sections, exact AX section filtering, and that
CGS move readback does not rescan all application AX trees.
