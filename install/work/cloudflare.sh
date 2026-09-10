#!/usr/bin/env bash
# cloudflare warp — the zero trust client that gates access to work resources.
#
# this is the first thing a new work machine needs: without a connected tunnel
# most internal endpoints (and therefore the rest of the work setup) are
# unreachable. run `make verify-cloudflare` afterwards to prove it works.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

# the zero trust org to enrol in. `registration new` falls back to whatever the
# MDM profile pins, so this is only needed when jamf hasn't set it yet.
WARP_ORG="${WARP_ORG:-aviv-group}"

require_macos
ensure_brew

log "cloudflare warp"
install_cask cloudflare-warp "Cloudflare WARP.app"

# the cask ships a pkg that drops warp-cli in /usr/local/bin; on a very fresh
# install the daemon takes a moment to come up before it answers commands.
if ! command -v warp-cli >/dev/null 2>&1; then
  export PATH="/usr/local/bin:$PATH"
fi
command -v warp-cli >/dev/null 2>&1 \
  || die "warp-cli not found after installing the cask — open the WARP app once, then re-run"

for _ in 1 2 3 4 5 6 7 8 9 10; do
  warp-cli status >/dev/null 2>&1 && break
  sleep 1
done

# registration is an SSO round trip through the browser, so it can't be done
# unattended — but it only has to happen once per machine.
if warp-cli registration show >/dev/null 2>&1; then
  skip "already registered with $(warp-cli registration organization 2>/dev/null || echo 'an org')"
else
  log "registering this device with the '$WARP_ORG' zero trust org"
  warn "this opens a browser for SSO — finish the login, then this continues"
  warp-cli registration new "$WARP_ORG" \
    || die "registration failed; run 'warp-cli registration new $WARP_ORG' by hand"
  ok "registered"
fi

# deliberately not setting the mode here: `warp-cli settings` reports it as
# "(network policy)", meaning the zero trust org pushes it centrally. forcing a
# local mode would just fight that policy, so only report what we were given.
# `|| true` because pipefail would otherwise abort the whole script if the
# daemon isn't answering yet — an unknown mode is not worth failing over
current_mode="$(warp-cli settings 2>/dev/null | awk -F'Mode: ' '/\tMode: / {print $2; exit}' || true)"
skip "mode is ${current_mode:-unknown} (managed by org policy)"

if warp-cli status 2>/dev/null | grep -q 'Connected'; then
  skip "already connected"
else
  log "connecting"
  warp-cli connect >/dev/null || warn "connect command failed, check the WARP app"
fi

ok "cloudflare warp done — run 'make verify-cloudflare' to confirm"
