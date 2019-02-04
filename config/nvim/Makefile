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
XDG_DATA_HOME ?= $(HOME)/.local/share

VIM_BIN := $(if $(shell command -v nvim),nvim,$(shell command -v vim))
VIM_VERSION := "$(shell $(VIM_BIN) --version)"
VIM_CACHEDIR ?= $(XDG_CACHE_HOME)/$(VIM_BIN)
VIM_DATADIR ?= $(XDG_DATA_HOME)/$(VIM_BIN)
VIM_VENVDIR ?= $(VIM_DATADIR)/virtualenvs
VIM_VENV := $(VIM_VENVDIR)/$(VIM_BIN)

# OS Specific
ifeq ($(KERNEL), Darwin)
# Set PYTHON version to a symlink that is version indempotent so that
# virtualenvs do not break on upgrade.
PYTHON ?= $(HOME)/Library/Homebrew/opt/python/libexec/bin/python
else
PYTHON ?= /usr/bin/python3
endif

#------------------------------
# Targets
#------------------------------
# Only needed for neovim.
$(VIM_VENV)/bin/pip:
	mkdir -p $(VIM_VENVDIR) && $(PYTHON) -m venv "$(VIM_VENV)"

.PHONY: virtualenv
virtualenv: $(VIM_VENV)/bin/pip
ifeq ('$(VIM_BIN)','nvim')
	$(VIM_VENV)/bin/pip install -U pip
	$(VIM_VENV)/bin/pip install -U pynvim PyYAML Send2Trash
else
	@echo "Neovim was not found. Not creating virtualenv."
endif

.PHONY: install
install:
	$(MAKE) virtualenv
	mkdir -vp "$(VIM_CACHEDIR)/"{backup,complete,session,swap,tags,undo}
	$(VIM_BIN) --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE \
		-c "try | call dein#update() | finally | call confirm('') | qall! | endtry"

.PHONY: update
update:
	$(MAKE) virtualenv
	$(VIM_BIN) --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE \
		-c "try | call dein#clear_state() | call dein#update() | call dein#recache_runtimepath() | finally | call confirm('') | qall! | endtry"

.PHONY: upgrade
upgrade: update

.PHONY: uninstall
uninstall:
	rm -rf "$(VIM_CACHEDIR)"
	rm -rf "$(VIM_DATADIR)"
	rm -rf "$(VIM_VENVDIR)"
