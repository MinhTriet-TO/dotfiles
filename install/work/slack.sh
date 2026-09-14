#!/usr/bin/env bash
# slack — install, then carry over look & feel.
#
# caveat worth knowing before reading the rest: slack keeps the sidebar theme
# and font size in your *account* prefs on their servers, not on disk. the
# local state file has theme/appearance/zoomLevel all null. so "apply the
# theme" cannot be a pure file copy — the theme string is stored in the repo
# (slack/theme.conf) and this script puts it on the clipboard so applying it on
# a fresh machine is one paste instead of rebuilding the palette from memory.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

THEME_CONF="$REPO_ROOT/slack/theme.conf"
SLACK_STATE="$HOME/Library/Application Support/Slack/storage/root-state.json"

require_macos
ensure_brew

log "slack"
install_cask slack "Slack.app"

[ -f "$THEME_CONF" ] || { warn "no $THEME_CONF, skipping look & feel"; exit 0; }
# shellcheck source=/dev/null
source "$THEME_CONF"

# --- sidebar theme -----------------------------------------------------------
if [ -n "${SLACK_THEME:-}" ]; then
  printf '%s' "$SLACK_THEME" | pbcopy
  ok "theme string copied to clipboard"
  echo "     paste it in: slack → preferences → themes → custom theme"
else
  warn "SLACK_THEME is empty in slack/theme.conf"
  echo "     capture it once from slack → preferences → themes → custom theme,"
  echo "     commit it, and every future machine gets it for free"
fi

# --- font size ---------------------------------------------------------------
# zoomLevel is one of the few look & feel values slack does persist locally,
# but it only reads the file at launch and overwrites it on quit — so touching
# it while slack is running would be silently thrown away.
if [ -z "${SLACK_ZOOM:-}" ]; then
  skip "SLACK_ZOOM not set, leaving font size alone"
elif [ ! -f "$SLACK_STATE" ]; then
  skip "slack hasn't created its state file yet — launch slack once, then re-run"
elif app_running Slack; then
  warn "slack is running, not touching font size (quit slack and re-run)"
else
  current="$(jq -r '.zoomLevel // "null"' "$SLACK_STATE")"
  if [ "$current" = "$SLACK_ZOOM" ]; then
    skip "font size already $SLACK_ZOOM"
  else
    cp "$SLACK_STATE" "$SLACK_STATE.pre-dotfiles"
    tmp="$(mktemp)"
    if jq --argjson z "$SLACK_ZOOM" '.zoomLevel = $z' "$SLACK_STATE" > "$tmp"; then
      mv "$tmp" "$SLACK_STATE"
      ok "font size set to $SLACK_ZOOM (was $current)"
    else
      rm -f "$tmp"
      warn "could not edit slack state, left it untouched"
    fi
  fi
fi

ok "slack done"
