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
# Cater for M1 arch
ifeq ($(ARCH), arm64)
BREW_PREFIX := /opt/homebrew
else
BREW_PREFIX := /usr/local
endif
else
BREW_PREFIX := /home/linuxbrew/.linuxbrew
endif

# Update PATH to include brew binaries. Subshells can now use just 'brew'.
PATH := $(BREW_PREFIX)/bin:$(BREW_PREFIX)/sbin:$(PATH)
export PATH

# Install Homebrew
# -----
$(BREW_PREFIX)/bin/brew:
	@echo "==============================="; \
	echo "Brew Prefix will be install here: $(BREW_PREFIX)"; \
	echo "==============================="; \
	read -p "Homebrew will be installed via shell script in the official repo. Please audit the script before continuing. Continue installation? [yY/nN]" -n 1 -r; \
	if [[ ! $${REPLY} =~ ^[Yy]$$ ]]; then \
	   exit 1; \
	fi; \
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)";

## Homebrew Install
brew-install: $(BREW_PREFIX)/bin/brew
.PHONY: brew-install

## Homebrew Bundle Install
brew-bundle: brew-install
	$(BREW_PREFIX)/bin/brew bundle --cleanup --quiet --verbose --zap
.PHONY: brew-bundle

# Dump current contents to Brewfile excl MAS packages.
# -----
## Homebrew Bundle Dump
brew-bundle-dump:
	brew bundle dump --describe --force --verbose
.PHONY: brew-bundle-dump

# Install LunarVim
# -----
$(HOME)/.local/bin/lunarvim: brew-bundle
	read -p "LunarVim will be installed via shell script in the official repo. Please audit the script before continuing. Continue installation? [yY/nN]" -n 1 -r; \
	if [[ ! $${REPLY} =~ ^[Yy]$$ ]]; then \
	   exit 1; \
	fi; \
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)";

## LunarVim Install
lunarvim-install: $(HOME)/.local/bin/lunarvim
.PHONY: lunarvim-install

## Python Install
python-install: brew-bundle
	pyenv install 3.7.13
	pyenv install 3.8.13
	pyenv install 3.9.11
	pyenv install 3.10.4
	pyenv global 3.7.13 3.8.13 3.9.11 3.10.4
.PHONY: python-install

# rcup options used:
# -d directory to install dotfiles from
# -f Force RC file creation
# -k Run pre and post hooks
# -v verbosity
# -----
## Dotfiles Install
dotfiles-install:
	RCRC="$(CURDIR)/config/rcm/rcrc" $(BREW_PREFIX)/bin/rcup -d $(CURDIR) -k -f -v
.PHONY: dotfiles-install

install: brew-bundle
	$(MAKE) dotfiles-install
	$(MAKE) lunarvim-install
	$(MAKE) python-install
.PHONY: install
