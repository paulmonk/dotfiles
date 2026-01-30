# Warn when if an undefined variable is used mainly to catch misspelled variables
MAKEFLAGS += --warn-undefined-variables

# This disables the bewildering array of built in rules to automatically build
# Yacc grammars out of your data if you accidentally add the wrong file suffix.
# Rules: https://www.gnu.org/software/make/manual/html_node/Catalogue-of-Rules.html
MAKEFLAGS += --no-builtin-rules

# Force Makefile to use Bash over Sh.
SHELL := /bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
# The -c flag is in the default value of .SHELLFLAGS and we must preserve it,
# because it is how make passes the script to be executed to bash.
.SHELLFLAGS := -euo pipefail -c

# Cancel out as not needed here.
.SUFFIXES:

# If no target is provided default to help.
.DEFAULT_GOAL := help

# HELP
#------------------------------
# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
.PHONY: help

#------------------------------
# Globals
#------------------------------
KERNEL := $(shell uname -s)
ARCH := $(shell uname -m)

XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share

export XDG_CACHE_HOME
export XDG_CONFIG_HOME
export XDG_DATA_HOME

#------------------------------
# Targets
#------------------------------
PREFIX := /opt/homebrew

# Ensure all required binaries on the PATH. Especially useful on first bootstrap of dotfiles.
# Reference this variable as required in a recipe
DEFAULT_PATH := "$(PREFIX)/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Install Homebrew
$(PREFIX)/bin/brew:
	@echo "==============================="
	@echo "Brew will be install here: $(PREFIX)"
	@echo "==============================="
	@read -p "Homebrew will be installed via shell script in the official repo. Please audit the script before continuing. Continue installation? [yY/nN]" -n 1 -r; \
	if [[ ! $${REPLY} =~ ^[Yy]$$ ]]; then \
		exit 1; \
	fi; \
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)";

## Homebrew Install
brew-bootstrap: $(PREFIX)/bin/brew
.PHONY: brew-bootstrap

## Homebrew Bundle Install
brew-bundle: brew-bootstrap
	@echo "================================================"
	@echo "Installing Homebrew Bundle"
	@echo ""
	@$(PREFIX)/bin/brew bundle --cleanup --quiet --verbose --zap
	@echo "================================================"
.PHONY: brew-bundle

# Dump current contents to Brewfile excl MAS packages.
# -----
## Homebrew Bundle Dump
brew-bundle-dump:
	@echo "================================================"
	@echo "Dumping Brewfile"
	@echo ""
	@$(PREFIX)/bin/brew bundle dump --describe --force --verbose --no-restart
	@echo "================================================"
.PHONY: brew-bundle-dump

## Setup Claude Code MCP servers
claude-code-mcp:
	@echo "================================================"
	@echo "Adding Claude Code MCP servers"
	@claude mcp add-json --scope user github '{"type":"http","url":"https://api.githubcopilot.com/mcp/","headers":{"Authorization":"Bearer $${GITHUB_TOKEN}"}}'
	@claude mcp add --scope user atlassian -- npx -y mcp-remote https://mcp.atlassian.com/v1/sse
	@claude mcp add --scope user firecrawl -- npx -y firecrawl-mcp -e FIRECRAWL_API_KEY
	@claude mcp add --scope user qmd -- $${BUN_INSTALL_BIN}/bin/qmd mcp
	@echo "MCP servers configured. Set GITHUB_TOKEN env var for GitHub MCP."
	@echo "================================================"
.PHONY: claude-code-mcp

# Dotfiles Setup
# -----
# rcup options used:
# -d directory to install dotfiles from
# -f Force RC file creation
# -k Run pre and post hooks
# -v verbosity
# -----
# Ensure RCUP is installed
$(PREFIX)/bin/rcup: brew-bootstrap
	@$(PREFIX)/bin/brew install --quiet rcm

## Dotfiles setup symlinks only
dotfiles: $(PREFIX)/bin/rcup
	@echo "================================================"
	@echo "Syncing dotfiles"
	@echo ""
	@RCRC="$(CURDIR)/config/rcm/rcrc" PATH="$(DEFAULT_PATH)" $(PREFIX)/bin/rcup -d $(CURDIR) -K -f -v
	@echo "================================================"
.PHONY: dotfiles

## Dotfiles Bootstrap, with pre and post hooks
dotfiles-bootstrap: $(PREFIX)/bin/rcup
	@echo "================================================"
	@echo "Bootstrapping dotfiles"
	@echo ""
	@RCRC="$(CURDIR)/config/rcm/rcrc" PATH="$(DEFAULT_PATH)" $(PREFIX)/bin/rcup -d $(CURDIR) -k -f -v
	@echo "================================================"
.PHONY: dotfiles-bootstrap

# Install
# -----
## Full install of all components
install: brew-bundle
	@$(MAKE) dotfiles-bootstrap
	@bun install -g https://github.com/tobi/qmd
	@$(MAKE) claude-code-mcp
.PHONY: install
