# Warn me when I use an undefined variable so I catch misspelled variables
MAKEFLAGS               += --warn-undefined-variables
SHELL                   := /usr/bin/env bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
# The -c flag is in the default value of .SHELLFLAGS and we must preserve it,
# because it is how make passes the script to be executed to bash.
.SHELLFLAGS             := -euo pipefail -c

.SUFFIXES:

.DEFAULT_GOAL           := install

#------------------------------
# Variables
#------------------------------
KERNEL := $(shell uname -s)
XDG_CACHE_HOME ?= $(HOME)/.cache

VIM_BIN := $(if $(shell command -v nvim),nvim,$(shell command -v vim))
VIM_VERSION := "$(shell $(VIM_BIN) --version)"
VIM_DATADIR ?= $(XDG_CACHE_HOME)/$(VIM_BIN)
VIM_VENV := $(VIM_DATADIR)/virtualenv

# OS Specific
ifeq ($(KERNEL), Darwin)
PREFIX ?= $(shell brew --prefix)
else
PREFIX ?= /usr
endif

#------------------------------
# Targets
#------------------------------
# Only needed for neovim.
$(VIM_VENV)/bin/pip:
	$(PREFIX)/bin/python3 -m venv "$(VIM_VENV)"

.PHONY: virtualenv
virtualenv: $(VIM_VENV)/bin/pip
ifeq ('$(VIM_BIN)','nvim')
	$(VIM_VENV)/bin/pip install -U pip
	$(VIM_VENV)/bin/pip install -U pynvim PyYAML Send2Trash
else
	$(error .. Neovim was not found. Not creating virtualenv.)
endif

.PHONY: install
install: virtualenv
	mkdir -vp "$(VIM_DATADIR)/"{backup,complete,session,swap,tags,undo}
	$(VIM_BIN) -V1 -es -i NONE -N -u config/init.vim -c "try | call dein#update() | finally | echomsg '' | qall! | endtry"

.PHONY: update
update: virtualenv
	$(VIM_BIN) -V1 -es -i NONE -N -u config/init.vim -c "try | call dein#clear_state() | call dein#update() | finally | qall! | endtry"

.PHONY: upgrade
upgrade: update

.PHONY: uninstall
uninstall:
	rm -rf "$(VIM_DATADIR)"
	rm -rf "$(VIM_VENV)"

.PHONY: test
test:
ifeq ('$(VIM_BIN)','nvim')
	$(info Testing NVIM 0.4+...)
	$(if $(shell echo "$(VIM_VERSION)" | egrep "NVIM v0\.[4-9]"),\
		$(info OK),\
		$(error .. You need Neovim 0.4.x or newer))
else
	$(info Testing VIM 8.x...)
	$(if $(shell echo "$(VIM_VERSION)" | egrep "VIM .* 8\."),\
		$(info OK),\
		$(error .. You need Vim 8.x or newer))

	$(info Testing +python3... )
	$(if $(findstring +python3,$(VIM_VERSION)),\
		$(info OK),\
		$(error .. MISSING! Install Vim 8.x or newer, with "+python3" enabled))
endif
	@echo All tests passed, hooray!
