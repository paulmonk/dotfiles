#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# .zlogin
# Executes commands at login post-zshrc
#------------------------------------------------------------------------------

# Execute code that does not affect the current session in the background.
{
  # Compile the completion dump to increase startup speed.
  if [[ -s "${ZCOMPDUMP}" && (! -s "${ZCOMPDUMP}.zwc" || "${ZCOMPDUMP}" -nt "${ZCOMPDUMP}.zwc") ]]; then
    zcompile "${ZCOMPDUMP}"
  fi
} &!

# Execute code only if STDERR is bound to a TTY.
[[ -o INTERACTIVE && -t 2 ]] && {

  # Print a random, hopefully interesting, adage.
  if (( $+commands[fortune] )); then
    fortune -s
    print
  fi

} >&2
