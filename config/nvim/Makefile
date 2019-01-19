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
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share

VIM_BIN := $(if $(shell command -v nvim),nvim,$(shell command -v vim))
VIM_CACHE_DIR := $(XDG_CACHE_HOME)/$(VIM_BIN)
VIM_DATA_DIR := $(XDG_DATA_HOME)/$(VIM_BIN)
VIM_VERSION := "$(shell $(VIM_BIN) --version)"
VIM_VENV_DIR := $(VIM_DATA_DIR)/virtualenvs
VIM_VENV_NVIM := $(VIM_VENV_DIR)/$(VIM_BIN)

#------------------------------
# Targets
#------------------------------
# Only needed for neovim.
$(VIM_VENV_NVIM)/bin/pip:
	mkdir -p $(VIM_VENV_DIR) && python3 -m venv "$(VIM_VENV_NVIM)"

.PHONY: virtualenv
virtualenv: $(VIM_VENV_NVIM)/bin/pip
ifeq ('$(VIM_BIN)','nvim')
	$(VIM_VENV_NVIM)/bin/pip install -U pip
	$(VIM_VENV_NVIM)/bin/pip install -U neovim PyYAML
else
	@echo "Neovim was not found. Not creating virtualenv."
endif

.PHONY: install
install:
	$(MAKE) virtualenv
	mkdir -vp "$(VIM_CACHE_DIR)/"{backup,complete,session,swap,tags,undo}
	mkdir -vp "$(VIM_DATA_DIR)/shada"
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
	rm -rf "$(VIM_CACHE_DIR)"
	rm -rf "$(VIM_DATA_DIR)"
	rm -rf "$(VIM_VENV_DIR)"
