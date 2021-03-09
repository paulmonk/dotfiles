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
.PHONY: help
help:
	@echo "==========================================================="
	@echo "DOTFILES DEPLOYMENT"
	@echo ""
	@echo "List of available recipes:"
	@echo "--------------------------"
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2> /dev/null \
		| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ \
		{if ($$1 !~ "^[#.]") {print $$1}}' \
			| sort \
				| egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo "==========================================================="

#------------------------------
# Globals
#------------------------------
KERNEL := $(shell uname -s)

XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share

export XDG_CACHE_HOME
export XDG_CONFIG_HOME
export XDG_DATA_HOME

#------------------------------
# Targets
#------------------------------
# Use a different prefix on macOS
ifeq ($(KERNEL), Darwin)
BREW_PREFIX := /usr/local
else
BREW_PREFIX := /home/linuxbrew/.linuxbrew
endif

# Update PATH to include brew binaries. Subshells can now use just 'brew'.
PATH := $(BREW_PREFIX)/bin:$(BREW_PREFIX)/sbin:$(PATH)
export PATH

# Install Homebrew
$(BREW_PREFIX)/bin/brew:
	@read -p "Homebrew will be installed via shell script in the official repo. Please audit the script before continuing. Continue installation? [yY/nN]" -n 1 -r; \
	if [[ ! $${REPLY} =~ ^[Yy]$$ ]]; then \
	   [[ "$$0" == "$${BASH_SOURCE}" ]] && exit 1 || return 1; \
	fi; \
	echo; \
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

.PHONY: brew-install
brew-install: $(BREW_PREFIX)/bin/brew

.PHONY: brew-bundle
brew-bundle: brew-install
	$(BREW_PREFIX)/bin/brew bundle --verbose

# rcup options used:
# -d directory to install dotfiles from
# -f Force RC file creation
# -k Run pre and post hooks
.PHONY: install
install: brew-bundle
	RCRC="$(CURDIR)/config/rcm/rcrc" $(BREW_PREFIX)/bin/rcup -d $(CURDIR) -k -f
