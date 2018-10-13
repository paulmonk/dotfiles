#!/bin/sh

#------------------------------------------------------------------------------
# Profile
#------------------------------------------------------------------------------

# Source exports if BASH.
# ZSH is handled in the .zshenv
if [ -n "${BASH}" ] && [ -s "${XDG_CONFIG_HOME}/sh/exports" ]; then
  # shellcheck source=/dev/null
  . "${XDG_CONFIG_HOME}/sh/exports"

  # . bashrc if bash.
  if [ -s "${HOME}/.bashrc" ]; then
    # shellcheck source=/dev/null
    . "${HOME}/.bashrc"
  fi
fi

# Start window manager if no display and tty1
if [ -z "${DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec startx
fi

#  vim: set ft=sh ts=2 sw=2 tw=80 et :
