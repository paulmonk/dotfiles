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
  source "${HOME}/.config/sh/exports"

  # ZSH Exports
  export ZCOMPDUMP="${XDG_CACHE_HOME}/zsh/compdump-${HOST}-${ZSH_VERSION}"
  export ZDOTDIR="${HOME}"
fi

# Autoloads
# ============
# Pyenv
if (( $+commands[pyenv] )); then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Asdf
if [[ -s "${ASDF_DATA_DIR:-$HOME/.asdf}/asdf.sh" ]]; then
  source "${ASDF_DATA_DIR:-$HOME/.asdf}/asdf.sh"
fi
