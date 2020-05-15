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
UID := $(shell id -u)
GROUP := $(shell id -g -n)
HOSTNAME := $(shell hostname)

XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share


#------------------------------
# Homebrew
#------------------------------
# Use a different prefix on macOS
ifeq ($(KERNEL), Darwin)
BREW_PREFIX ?= $(HOME)/Library/Homebrew
PREFIX ?= $(BREW_PREFIX)
else
BREW_PREFIX ?= $(XDG_DATA_HOME)/Homebrew
PREFIX ?= "/usr"
endif

# Update PATH to include brew binaries. Subshells can now use just 'brew'.
PATH := $(BREW_PREFIX)/bin:$(BREW_PREFIX)/sbin:$(PATH)

# Ensure prefix exists.
$(BREW_PREFIX):
	mkdir -vp $@

# Install Homebrew
$(BREW_PREFIX)/bin/brew: | $(BREW_PREFIX)
	curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $(BREW_PREFIX) && $@ update

# Brewfile
.PHONY: brew-bundle
brew-bundle: Brewfile | $(BREW_PREFIX)/bin/brew
	brew bundle


#  vim: set ts=8 sw=8 tw=80 noet :
