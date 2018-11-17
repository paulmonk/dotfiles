#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# .zshrc is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Opts
#-------------------------
source "${XDG_CONFIG_HOME}/zsh/opts"

# Plugins
#-------------------------
source "${XDG_CONFIG_HOME}/zsh/plugins"

# Sh
#-------------------------
source "${XDG_CONFIG_HOME}/sh/aliases"
source "${XDG_CONFIG_HOME}/sh/colors"
source "${XDG_CONFIG_HOME}/sh/gpg-agent"

# ZSH Keybindings
#-------------------------
source "${XDG_CONFIG_HOME}/zsh/keybindings"

# ZSH Aliases
#-------------------------
source "${XDG_CONFIG_HOME}/zsh/aliases"

# ZSH Functions
#-------------------------
# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
if [[ -d "${XDG_CONFIG_HOME}/zsh/functions" ]]; then
  fpath=(
    ${XDG_CONFIG_HOME}/zsh/functions
    ${fpath}
  )
fi
for func in $^fpath/*(N-.x:t); do
  autoload -Uz "${func}";
done

# ZSH Commands
# Source all shell command specific config
#-------------------------
if [[ -d "${XDG_CONFIG_HOME}/zsh/commands" ]]; then
  for bin in ${XDG_CONFIG_HOME}/zsh/commands/*; do
    cmd=$(basename "${bin}")
    if (( $+commands[$cmd] )) && [[ -s "${bin}" ]]; then
      source "${bin}";
    fi
  done
fi

# ZSH Sandboxd
#-------------------------
source "${XDG_CONFIG_HOME}/zsh/sandboxd"

# ZSH Completions
#-------------------------
if [[ -d "${XDG_CONFIG_HOME}/zsh/completions" ]]; then
  fpath=(
    ${XDG_CONFIG_HOME}/zsh/completions
    ${fpath}
  )
  if [[ ${OSTYPE} == "*darwin*" ]]; then
    fpath=(
      ${PREFIX}/share/zsh/site-functions
      ${fpath}
    )
  fi
fi

# Load completions and bash completions
autoload -Uz compinit && compinit -i -d "${ZCOMPDUMP}"
autoload -Uz bashcompinit && bashcompinit
