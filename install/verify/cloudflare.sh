#!/usr/bin/env bash
# prove cloudflare warp actually works, rather than just being installed.
#
# checks run cheapest-first and the script keeps going after a failure so one
# run tells you everything that's wrong. exits non-zero if any check failed,
# so it can gate the rest of a bootstrap.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

# a failed check shouldn't abort the run — we want the full picture
set +e

failed=0
check() {
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then
    ok "$label"
  else
    fail "$label"
    failed=$((failed + 1))
  fi
}

log "verifying cloudflare warp"

# 1. is it even installed
check "WARP app present" test -d "/Applications/Cloudflare WARP.app"

command -v warp-cli >/dev/null 2>&1 || export PATH="/usr/local/bin:$PATH"
check "warp-cli on PATH" command -v warp-cli

if ! command -v warp-cli >/dev/null 2>&1; then
  fail "cannot continue without warp-cli"
  exit 1
fi

# 2. is the background daemon answering
check "warp daemon responding" warp-cli status

# 3. is this device enrolled in the zero trust org
if org="$(warp-cli registration organization 2>/dev/null)" && [ -n "$org" ]; then
  ok "registered with zero trust org '$org'"
else
  fail "not registered — run 'warp-cli registration new <org>'"
  failed=$((failed + 1))
fi

# 4. is the tunnel up and healthy. -j keeps this parseable across versions
status_json="$(warp-cli -j status 2>/dev/null)"
state="$(printf '%s' "$status_json" | jq -r '.status // empty' 2>/dev/null)"
reason="$(printf '%s' "$status_json" | jq -r '.reason // empty' 2>/dev/null)"
if [ "$state" = "Connected" ]; then
  ok "tunnel connected (${reason:-no reason given})"
else
  fail "tunnel not connected (status=${state:-unknown}) — run 'warp-cli connect'"
  failed=$((failed + 1))
fi

# 5. the check that actually matters: is our egress traffic going through warp?
#    cloudflare's own trace endpoint reports this back to us.
trace="$(curl -fsS --max-time 10 https://www.cloudflare.com/cdn-cgi/trace 2>/dev/null)"
if [ -z "$trace" ]; then
  fail "could not reach cloudflare trace endpoint — no usable network"
  failed=$((failed + 1))
else
  if printf '%s' "$trace" | grep -q '^warp=on'; then
    ok "traffic is flowing through warp"
  else
    fail "traffic is NOT going through warp ($(printf '%s' "$trace" | grep '^warp=' || echo 'warp=?'))"
    failed=$((failed + 1))
  fi

  # gateway=on means zero trust dns/http filtering is applied, which is the
  # part work access depends on — a plain consumer tunnel isn't enough.
  if printf '%s' "$trace" | grep -q '^gateway=on'; then
    ok "zero trust gateway is active"
  else
    warn "gateway is off — tunnel is up but zero trust filtering isn't applied"
  fi

  loc="$(printf '%s' "$trace" | awk -F= '/^loc=/ {print $2}')"
  [ -n "$loc" ] && skip "egress location: $loc"
fi

echo
if [ "$failed" -eq 0 ]; then
  ok "cloudflare warp is working"
  exit 0
fi
die "$failed cloudflare check(s) failed"
