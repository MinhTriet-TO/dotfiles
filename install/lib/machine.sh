#!/usr/bin/env bash
# print "work" or "personal" for the machine we're running on.
#
# the objective is that `make run` behaves correctly on a *fresh* machine with
# no state to read, so detection leans on MDM enrollment: work laptops are
# DEP-enrolled in the company jamf, a personal mac is not managed at all.
#
# precedence: explicit env var > pinned marker file > MDM guess.
# to pin a machine permanently:  echo personal > ~/.dotfiles-machine

set -euo pipefail

if [ -n "${MACHINE:-}" ]; then
  echo "$MACHINE"
  exit 0
fi

if [ -f "$HOME/.dotfiles-machine" ]; then
  tr -d '[:space:]' < "$HOME/.dotfiles-machine"
  echo
  exit 0
fi

if [ "$(uname -s)" = "Darwin" ] \
  && profiles status -type enrollment 2>/dev/null | grep -qi 'MDM enrollment: *Yes'; then
  echo work
else
  echo personal
fi
