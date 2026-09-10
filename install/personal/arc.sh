#!/usr/bin/env bash
# arc — install, then restore spaces / profiles / bookmarks.
#
# the spec asks to "restore spaces, profiles, bookmark", and the honest answer
# is that this is a sign-in, not a file copy. arc keeps that state in its own
# account and syncs it down on login; the local files are a cache
# (StorableSidebar.json and friends under ~/Library/Application Support/Arc).
#
# two reasons not to copy those files into the repo, even though it would look
# more "automated":
#   1. this repo is public. StorableSidebar.json contains every space, pinned
#      tab and bookmark URL, and StorableAuthState.json holds session state.
#   2. arc rewrites them on its own schedule and they reference an account and
#      an encryption key, so a transplanted copy is not portable anyway.
#
# so: install, hand off the sign-in, and keep a local (never committed) backup
# for same-machine recovery.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

ARC_SUPPORT="$HOME/Library/Application Support/Arc"
BACKUP_DIR="$HOME/.dotfiles-backups/arc"

require_macos
ensure_brew

log "arc"
install_cask arc "Arc.app"

# --- sign-in -----------------------------------------------------------------
# the auth state file is the cheapest signal for "has anyone logged in here".
if [ -f "$ARC_SUPPORT/StorableAuthState.json" ]; then
  ok "already signed in — spaces, profiles and bookmarks sync from your arc account"
else
  warn "not signed in yet"
  echo "     open arc and sign in; spaces, profiles and bookmarks then sync down"
  echo "     on their own. there is nothing to restore by hand."
fi

# --- local backup ------------------------------------------------------------
# same-machine safety net only: if arc corrupts its sidebar, this is the
# fallback. deliberately outside the repo — see the header.
if [ -d "$ARC_SUPPORT" ]; then
  mkdir -p "$BACKUP_DIR"
  stamp="$(date +%Y%m%d%H%M%S)"
  backed_up=0
  for f in StorableSidebar.json StorableArchiveItems.json; do
    if [ -f "$ARC_SUPPORT/$f" ]; then
      cp "$ARC_SUPPORT/$f" "$BACKUP_DIR/$f.$stamp"
      backed_up=$((backed_up + 1))
    fi
  done
  if [ "$backed_up" -gt 0 ]; then
    ok "backed up $backed_up arc state file(s) to ${BACKUP_DIR/#$HOME/~}"
    # keep the last 5 of each so this doesn't grow without bound
    for f in StorableSidebar.json StorableArchiveItems.json; do
      ls -1t "$BACKUP_DIR/$f."* 2>/dev/null | tail -n +6 | while read -r old; do
        rm -f "$old"
      done
    done
  fi
else
  skip "no arc state yet (launch arc once to create it)"
fi

ok "arc done"
