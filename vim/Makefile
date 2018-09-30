# Credit: https://github.com/rafi/vim-config
SHELL = /bin/bash

# Clear the suffix list; no suffix rules in this makefile.
# See section 7.2.1 of the GNU
# https://www.gnu.org/prep/standards/standards.html#Makefile-Basics
.SUFFIXES:

.DEFAULT_GOAL = install

#------------------------------
# Custom Globals
#------------------------------
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share

# Vim
vim := $(if $(shell command -v nvim),nvim,$(shell command -v vim))
vim_version := '${shell $(vim) --version}'

.PHONY: install
install:
	@mkdir -vp "$(XDG_CACHE_HOME)/vim/"{backup,session,swap,tags,undo} && \
	mkdir -vp "$(XDG_DATA_HOME)/vim" && \
	$(vim) --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE \
		-c "try | call dein#update() | finally | call confirm('') | qall! | endtry"

.PHONY: update
update:
	$(vim) --cmd 'set t_ti= t_te= nomore' -N -U NONE -i NONE \
		-c "try | call dein#clear_state() | call dein#update() | call dein#recache_runtimepath() | finally | call confirm('') | qall! | endtry"

.PHONY: upgrade
upgrade: update

.PHONY: uninstall
uninstall:
	rm -rf "$(XDG_CACHE_HOME)/vim"
	rm -rf "$(XDG_DATA_HOME)/vim"

.PHONY: test
test:
ifeq ('$(vim)','nvim')
	$(info Testing NVIM...)
	$(if $(findstring NVIM,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Is Neovim available in PATH?))
else
	$(info Testing VIM 7.4...)
	$(if $(findstring 7.4,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Install newer $nvim version))

	$(info Testing +lua... )
	$(if $(findstring +lua,$(vim_version)),\
		$(info OK),\
		$(error   .. MISSING! Install $nvim with "+lua" enabled))

	$(info Testing +python... )
	$(if $(findstring +python,$(vim_version)),\
		$(info OK),\
		$(error .. MISSING! Install $nvim with "+python" enabled))
endif
	@echo All tests passed, hooray!
