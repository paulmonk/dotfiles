#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# This file contains most of our environment exports.
#------------------------------------------------------------------------------
# Don't load default zshrc
unsetopt GLOBAL_RCS

# Dump all aliases before load.
unalias -m '*'

# Source exports.
if [[ -s "${HOME}/.config/sh/exports" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.config/sh/exports"

  # ZSH Exports
  export ZCOMPDUMP="${XDG_CACHE_HOME}/zsh/compdump-${HOST}-${ZSH_VERSION}"
fi
