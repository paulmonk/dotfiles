#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# zprofile
#------------------------------------------------------------------------------
[[ -s "${HOME}/.profile" ]] && source "${HOME}/.profile"

# Mise Shims for IDE Integration
# https://mise.jdx.dev/ide-integration.html
if (( $+commands[mise] )); then
  eval "$(mise activate zsh --shims)"
fi
