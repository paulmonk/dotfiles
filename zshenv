#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# This file contains most of our environment exports.
#------------------------------------------------------------------------------
# Don't load default zshrc
unsetopt GLOBAL_RCS

XDG_CONFIG_HOME="${HOME}/.config"

# Source exports.
if [[ -s "${XDG_CONFIG_HOME}/sh/exports" ]]; then
  # shellcheck source=/dev/null
  source "${XDG_CONFIG_HOME}/sh/exports"

  # ZSH Exports
  export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
  export ZCOMPDUMP="${XDG_CACHE_HOME}/zsh/compdump-${HOST}-${ZSH_VERSION}"
fi
