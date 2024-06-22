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
# Use a different prefix on macOS
ifeq ($(KERNEL), Darwin)

# Cater for M1 arm arch
ifeq ($(ARCH), arm64)
PREFIX := /opt/homebrew
X86_PREFIX := /usr/local

# Cater for Intel
else
PREFIX := /usr/local
X86_PREFIX := /usr/local
endif

# Linux
else
PREFIX := /usr
# This is not necessary on Linux so just set to /usr to catch all
X86_PREFIX := /usr
endif

# Install Homebrew
# -----
ifeq ($(KERNEL), Darwin)
$(PREFIX)/bin/brew:
	@echo "==============================="; \
	echo "Brew will be install here: $(PREFIX)"; \
	echo "==============================="; \
	read -p "Homebrew will be installed via shell script in the official repo. Please audit the script before continuing. Continue installation? [yY/nN]" -n 1 -r; \
	if [[ ! $${REPLY} =~ ^[Yy]$$ ]]; then \
	   exit 1; \
	fi; \
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)";

$(X86_PREFIX)/bin/brew:
	@echo "==============================="; \
	echo "Brew (X86) will be install here: $(X86_PREFIX)"; \
	echo "==============================="; \
	echo "Ensuring rosetta is installed."; \
	softwareupdate --install-rosetta; \
	read -p "Homebrew will be installed via shell script in the official repo. Please audit the script before continuing. Continue installation? [yY/nN]" -n 1 -r; \
	if [[ ! $${REPLY} =~ ^[Yy]$$ ]]; then \
	   exit 1; \
	fi; \
	arch -x86_64 /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)";

## Homebrew Install
brew-bootstrap: $(PREFIX)/bin/brew $(X86_PREFIX)/bin/brew
.PHONY: brew-bootstrap

## Homebrew Bundle Install
brew-bundle: brew-bootstrap
	$(PREFIX)/bin/brew bundle --cleanup --quiet --verbose --zap
.PHONY: brew-bundle

# Dump current contents to Brewfile excl MAS packages.
# -----
## Homebrew Bundle Dump
brew-bundle-dump:
	$(PREFIX)/bin/brew bundle dump --describe --force --verbose --no-restart
.PHONY: brew-bundle-dump
endif

# Install LunarVim
# -----
LVIM_BRANCH := "master"

$(HOME)/.local/bin/lvim:
	read -p "LunarVim will be installed via shell script in the official repo. Please audit the script before continuing. Continue installation? [yY/nN]" -n 1 -r; \
	if [[ ! $${REPLY} =~ ^[Yy]$$ ]]; then \
	   exit 1; \
	fi; \
	LV_BRANCH="$(LVIM_BRANCH)" /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/LunarVim/LunarVim/$(LVIM_BRANCH)/utils/installer/install.sh)";

## LunarVim Install
lunarvim-bootstrap: $(HOME)/.local/bin/lvim
.PHONY: lunarvim-bootstrap

## Python Install
python-bootstrap:
	$(PREFIX)/bin/pyenv install 3.10:latest
	$(PREFIX)/bin/pyenv install 3.11:latest
	$(PREFIX)/bin/pyenv install 3.12:latest
.PHONY: python-bootstrap

# Dotfiles Setup
# -----
# rcup options used:
# -d directory to install dotfiles from
# -f Force RC file creation
# -k Run pre and post hooks
# -v verbosity
# -----
# Ensure RCUP is installed
ifeq ($(KERNEL), Darwin)
$(PREFIX)/bin/rcup: brew-bootstrap
	$(PREFIX)/bin/brew install rcm
else
$(PREFIX)/bin/rcup:
	apt update && apt install -y rcm
endif

## Dotfiles setup symlinks only
dotfiles: $(PREFIX)/bin/rcup
	RCRC="$(CURDIR)/config/rcm/rcrc" $(PREFIX)/bin/rcup -d $(CURDIR) -K -f -v
.PHONY: dotfiles

## Dotfiles Bootstrap, with pre and post hooks
dotfiles-bootstrap: $(PREFIX)/bin/rcup
	RCRC="$(CURDIR)/config/rcm/rcrc" $(PREFIX)/bin/rcup -d $(CURDIR) -k -f -v
.PHONY: dotfiles-bootstrap

# Install
# -----
## Full install of all components
install: brew-bundle
	$(MAKE) dotfiles-bootstrap
	$(MAKE) lunarvim-bootstrap
	$(MAKE) python-bootstrap
.PHONY: install
