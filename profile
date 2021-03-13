#!/bin/sh

#------------------------------------------------------------------------------
# Profile
#------------------------------------------------------------------------------

# Source exports if BASH.
# ZSH is handled in the .zshenv
if [ -n "${BASH}" ] && [ -s "${HOME}/.config/sh/exports" ]; then
  # shellcheck source=/dev/null
  . "${HOME}/.config/sh/exports"

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
