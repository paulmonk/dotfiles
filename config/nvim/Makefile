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
# Custom Globals
#------------------------------
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share

VIM_BIN := $(if $(shell command -v nvim),nvim,$(shell command -v vim))
VIM_VERSION := "${shell $(VIM_BIN) --version}"
VIM_VENVS := ${XDG_DATA_HOME}/nvim/virtualenvs

$(VIM_VENVS)/neovim/bin/python:
	mkdir -p $(VIM_VENVS) && python3 -m venv "$(VIM_VENVS)/neovim"

.PHONY: virtualenv
virtualenv: $(VIM_VENVS)/neovim/bin/python
	$(VIM_VENVS)/neovim/bin/pip install -U pip
	$(VIM_VENVS)/neovim/bin/pip install -U neovim PyYAML

.PHONY: install
install:
	$(MAKE) virtualenv
	mkdir -vp "$(XDG_CACHE_HOME)/nvim/"{backup,complete,session,swap,tags,undo}
	mkdir -vp "$(XDG_DATA_HOME)/nvim/shada"
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
	rm -rf "$(XDG_CACHE_HOME)/nvim"
	rm -rf "$(XDG_DATA_HOME)/nvim"
