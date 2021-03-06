#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# .zlogin
# Executes commands at login post-zshrc
#------------------------------------------------------------------------------
# Execute code only if STDERR is bound to a TTY.
[[ -o INTERACTIVE && -t 2 ]] && {

  # Print a random, hopefully interesting, adage.
  if (( $+commands[fortune] )); then
    fortune -s
    print
  fi

} >&2
