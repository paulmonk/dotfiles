#!/usr/bin/env bash

# shellcheck source=/dev/null

#------------------------------------------------------------------------------
# .bashrc is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#------------------------------------------------------------------------------
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Bash settings
#-------------------------
# Remove the ^S ^Q mappings. See all mappings: stty -a
stty stop undef
stty start undef

# Bash settings
shopt -s cdspell        # Autocorrects cd misspellings
shopt -s checkwinsize   # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist        # Save multi-line commands in history as single line
shopt -s dotglob        # Include dotfiles in pathname expansion
shopt -s expand_aliases # Expand aliases
shopt -s extglob        # Enable extended pattern-matching features
shopt -s histreedit     # Add failed commands to the bash history
shopt -s histappend     # Append each session's history to $HISTFILE
shopt -s histverify     # Edit a recalled history line before executing

export HISTSIZE=2000
export HISTFILESIZE=50000
export HISTTIMEFORMAT='[%F %T] '
export HISTIGNORE='pwd:jobs:ll:ls:l:fg:history:clear:exit:pass'
export HISTCONTROL=ignoreboth
export HISTFILE="${XDG_DATA_HOME}/bash_history"

# Append to history and set the window title to user@host:dir
PROMPT_COMMAND='history -a; echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

# Source Config
#-------------------------
# Source aliases
[[ -s "${XDG_CONFIG_HOME}/sh/aliases" ]] && source "${XDG_CONFIG_HOME}/sh/aliases"

# Load directory and file colors for GNU ls
[[ -s "${XDG_CONFIG_HOME}/sh/colors" ]] && source "${XDG_CONFIG_HOME}/sh/colors"

# Sets gpg-agent
[[ -s "${XDG_CONFIG_HOME}/sh/gpg-agent" ]] && source "${XDG_CONFIG_HOME}/sh/gpg-agent"

# Source bash completions
[[ -s "${XDG_CONFIG_HOME}/bash/completions" ]] && source "${XDG_CONFIG_HOME}/bash/completions"
[[ -s "${XDG_CONFIG_HOME}/bash/dbt-completions" ]] && source "${XDG_CONFIG_HOME}/bash/dbt-completions"
