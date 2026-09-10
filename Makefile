# dotfiles bootstrap.
#
# the whole point: clone this repo on a fresh machine, run `make run`, get a
# working setup. work machines get work tools *and* personal tools; personal
# machines get only the personal ones. the split is detected from MDM
# enrollment (see install/lib/machine.sh) and can be overridden:
#
#   make run                  # detect, then install what fits
#   make run MACHINE=personal # force the personal-only path
#   make work                 # just the work tools
#   make verify               # prove the installed tools actually work

SHELL := /bin/bash

# recursively expanded on purpose: only shells out when a target reads it
MACHINE ?= $(shell bash install/lib/machine.sh)

WORK_TOOLS := cloudflare slack qgis
PERSONAL_TOOLS := arc vscode
# terminal setup, built up one piece at a time: nvim still to come
TERMINAL_TOOLS := zsh wezterm tmux

.DEFAULT_GOAL := help
.PHONY: help run github link work personal terminal verify detect \
	$(addprefix work-,$(WORK_TOOLS)) $(addprefix personal-,$(PERSONAL_TOOLS)) \
	$(addprefix terminal-,$(TERMINAL_TOOLS)) verify-cloudflare

help:
	@echo "dotfiles — targets:"
	@echo ""
	@echo "  make github       step 0: ssh access to github + git identity"
	@echo "  make link         symlink configs out of the repo into place"
	@echo "  make run          install everything this machine should have"
	@echo "  make work         install work tools ($(WORK_TOOLS))"
	@echo "  make personal     install personal tools ($(PERSONAL_TOOLS))"
	@echo "  make terminal     install terminal setup ($(TERMINAL_TOOLS))"
	@echo "  make verify       check the installed tools actually work"
	@echo "  make detect       print whether this looks like a work or personal machine"
	@echo ""
	@echo "  individual tools: $(addprefix work-,$(WORK_TOOLS)) $(addprefix personal-,$(PERSONAL_TOOLS))"
	@echo ""
	@echo "  override detection with MACHINE=work|personal"

detect:
	@echo "$(MACHINE)"

run:
	@echo "==> machine detected as: $(MACHINE)"
	@$(MAKE) --no-print-directory link
	@if [ "$(MACHINE)" = "work" ]; then $(MAKE) --no-print-directory work; fi
	@$(MAKE) --no-print-directory personal

link:
	@bash install/link.sh

# cloudflare goes first by design: it gates access to work resources, so the
# later tools may need the tunnel up. the explicit recipe lines (rather than
# prerequisites) keep that order even under `make -j`.
work:
	@$(MAKE) --no-print-directory work-cloudflare
	@$(MAKE) --no-print-directory work-slack
	@$(MAKE) --no-print-directory work-qgis
	@echo "==> work tools done — run 'make verify' to check them"

# one `work-<tool>` target per tool, generated so adding a tool means editing
# WORK_TOOLS only. these have to be real explicit rules rather than a `work-%`
# pattern: make skips implicit-rule search for .PHONY targets, so a pattern
# rule would silently resolve to "nothing to be done".
define WORK_TOOL_RULE
work-$(1):
	@bash install/work/$(1).sh
endef
$(foreach tool,$(WORK_TOOLS),$(eval $(call WORK_TOOL_RULE,$(tool))))

# step 0, kept out of `run` on purpose: it's what you need *before* the repo
# exists, and it's interactive (pasting a key into github).
github:
	@bash install/bootstrap/github.sh

# the terminal setup is part of "personal tools" in the spec, so it runs on
# both machine kinds — it just lives in its own directory because it's several
# pieces (zsh now, tmux and nvim next).
personal:
	@$(MAKE) --no-print-directory personal-arc
	@$(MAKE) --no-print-directory personal-vscode
	@$(MAKE) --no-print-directory terminal

terminal:
	@$(MAKE) --no-print-directory terminal-zsh
	@$(MAKE) --no-print-directory terminal-wezterm
	@$(MAKE) --no-print-directory terminal-tmux

define TERMINAL_TOOL_RULE
terminal-$(1):
	@bash install/terminal/$(1).sh
endef
$(foreach tool,$(TERMINAL_TOOLS),$(eval $(call TERMINAL_TOOL_RULE,$(tool))))

define PERSONAL_TOOL_RULE
personal-$(1):
	@bash install/personal/$(1).sh
endef
$(foreach tool,$(PERSONAL_TOOLS),$(eval $(call PERSONAL_TOOL_RULE,$(tool))))

verify:
	@$(MAKE) --no-print-directory verify-cloudflare

verify-cloudflare:
	@bash install/verify/cloudflare.sh
