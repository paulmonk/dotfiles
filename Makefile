# Warn me when I use an undefined variable so I catch misspelled variables
MAKEFLAGS               += --warn-undefined-variables
SHELL                   := /usr/bin/env bash

# The -e flag causes bash with qualifications to exit immediately if a
# command it executes fails.

# The -u flag causes bash to exit with an error message if a variable is
# accessed without being defined.

# The -c flag is in the default value of .SHELLFLAGS and we must preserve it,
# because it is how make passes the script to be executed to bash.
.SHELLFLAGS             := -eu -o pipefail -c

.SUFFIXES:

.DEFAULT_GOAL           := help

# HELP
#------------------------------
.PHONY: help
help:
	@echo "==========================================================="
	@echo "DOTFILES DEPLOYMENT"
	@echo "==========================================================="
	@echo ""
	@echo "List of available recipes:"
	@echo "--------------------------"
	@$(MAKE) -pRrq -f $(firstword $(MAKEFILE_LIST)) : 2> /dev/null \
		| awk -v RS= -F: '/^# File/,/^# Finished Make data base/ \
		{if ($$1 !~ "^[#.]") {print $$1}}' \
			| sort \
				| egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


# MAIN
#------------------------------
sync:
	RCRC=$(realpath ./config/rcm/rcrc) rcup -d $(PWD) -f

.PHONY: update-submodules
update-submodules:
	git submodule update --init
	git submodule foreach --recursive "git checkout master"
	git submodule foreach --recursive "git pull"

#  vim: set ts=8 sw=8 tw=80 noet :
