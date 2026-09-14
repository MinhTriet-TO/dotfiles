#!/usr/bin/env bash
# qgis — desktop GIS. install only; the spec asks for nothing beyond that.
#
# the cask installs a *versioned* bundle — 4.2.2 lands as
# "QGIS-final-4_2_2.app" — so the fallback bundle check is a glob. brew's own
# records are checked first and cover the normal case.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

require_macos
ensure_brew

log "qgis"
install_cask qgis "QGIS*.app"

ok "qgis done"
