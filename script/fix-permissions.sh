#!/bin/bash
# Re-grant Accessibility / Screen Recording after installing an update.
# Usage: ./script/fix-permissions.sh [/path/to/Floe.app]
#
# Release builds are ad-hoc signed, so the app's designated requirement is a
# pinned cdhash rather than a stable Developer ID. Every build has a different
# hash, so the csreq macOS stored when you first granted access stops matching:
# System Settings keeps showing the toggle as on while tccd denies the app.
# Dropping the stale rows lets the next grant bind to the new signature.
set -e

APP="${1:-/Applications/Floe.app}"
BUNDLE_ID="com.wudb.Floe"

if [[ ! -d "$APP" ]]; then
  echo "not found: $APP"
  echo "usage: $0 [/path/to/Floe.app]"
  exit 1
fi

echo "Floe: $APP"
codesign -dvvv "$APP" 2>&1 | grep -E 'CDHash=|flags=' | sed 's/^/  /' || true
echo

# tccd caches authorization for a running process, so quit before resetting —
# otherwise Floe stays half-denied until the next launch anyway. Match the
# executable name rather than the bundle path: it is path-independent and never
# treats the path as a regex (same form as script/run.sh).
if pgrep -x Floe >/dev/null 2>&1; then
  echo "quitting Floe"
  osascript -e 'quit app "Floe"' 2>/dev/null || true
  sleep 2
  pkill -x Floe 2>/dev/null || true
  sleep 1
fi

echo "resetting TCC entries for $BUNDLE_ID"
# tccutil exits 64 when TCC holds no record for the bundle id at all (a fresh
# install that has never prompted) — expected, not a failure. Anything else
# nonzero is a real error and must not be reported as success.
FAILED=0
for SERVICE in Accessibility ScreenCapture ListenEvent PostEvent; do
  if OUTPUT=$(tccutil reset "$SERVICE" "$BUNDLE_ID" 2>&1); then
    STATUS=0
  else
    STATUS=$?
  fi
  case "$STATUS" in
    0)  echo "  $SERVICE — reset" ;;
    64) echo "  $SERVICE — no TCC record, nothing to reset" ;;
    *)  echo "  $SERVICE — failed (exit $STATUS): $OUTPUT" >&2; FAILED=1 ;;
  esac
done

echo
echo "relaunching Floe"
open "$APP"
sleep 3
pgrep -x Floe >/dev/null 2>&1 || echo "warning: Floe did not start"

cat <<'EOF'

Now re-grant in System Settings > Privacy & Security:
  Accessibility      hiding and moving menu bar items
  Screen Recording   menu bar item images, Floe Bar

If a greyed-out Floe entry is still listed, select it, press "-", then let Floe
prompt again.
EOF

# Report a real tccutil failure even though the rest of the run succeeded —
# stale entries may still be in place, so the re-grant will not stick.
exit "$FAILED"
