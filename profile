#!/bin/sh

#------------------------------------------------------------------------------
# Profile
#------------------------------------------------------------------------------

PREFIX="/usr"
XDG_CONFIG_HOME="${HOME}/.config"

# Source exports if BASH.
# ZSH is handled in the .zshenv
if [ -n "${BASH}" ] && [ -s "${XDG_CONFIG_HOME}/sh/exports" ]; then
  # shellcheck source=/dev/null
  . "${XDG_CONFIG_HOME}/sh/exports"

  # . bashrc if bash.
  if [ -s "${XDG_CONFIG_HOME}/bash/bashrc" ]; then
    # shellcheck source=/dev/null
    . "${XDG_CONFIG_HOME}/bash/bashrc"
  fi
fi

# If SSH session and not running tmux, list tmux sessions on log-in.
if [ -n "${SSH_TTY}" ] && [ -z "${TMUX}" ] && command -v "${PREFIX}/bin/tmux" >/dev/null 2>&1; then
  exec "${PREFIX}/bin/tmux" list-sessions >/dev/null 2>&1 | sed 's/^/# tmux /'
  # Else Start window manager if no display and tty1
elif [ -z "${DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec "${PREFIX}/bin/startx"
fi

#  vim: set ft=sh ts=2 sw=2 tw=80 et :
