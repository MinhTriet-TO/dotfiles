#!/usr/bin/env bash
# qgis — desktop GIS. install only; the spec asks for nothing beyond that.
#
# note the cask installs a versioned app bundle (QGIS.app today, but past
# releases have shipped as QGIS3.app), so detection checks brew's own records
# first and only falls back to the bundle name.

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)/common.sh"

require_macos
ensure_brew

log "qgis"
install_cask qgis "QGIS.app"

ok "qgis done"
