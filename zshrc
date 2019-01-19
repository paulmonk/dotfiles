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
# Load antigen
# https://github.com/zsh-users/antigen/wiki/Configuration
export ADOTDIR="${XDG_DATA_HOME}/zsh/antigen"
export ANTIGEN_BUNDLES="${ADOTDIR}/bundles"

# Note: These non export-vars below are not official exports
ANTIGEN_CACHE_DIR="${XDG_CACHE_HOME}/zsh/antigen"
ANTIGEN_REPO_DIR="${ADOTDIR}/repo"
ANTIGEN_BIN="${ANTIGEN_REPO_DIR}/antigen.zsh"

export ANTIGEN_CACHE="${ANTIGEN_CACHE_DIR}/init.zsh"
export ANTIGEN_COMPDUMP="${ANTIGEN_CACHE_DIR}/compdump-${HOST}-${ZSH_VERSION}"
export ANTIGEN_DEBUG_LOG="${ANTIGEN_CACHE_DIR}/debug.log"
export ANTIGEN_LOCK="${ANTIGEN_CACHE_DIR}/lock"

# Create antigen dirs/files if they do not exist.
[[ -d "${ADOTDIR}" ]] || mkdir -p "${ADOTDIR}"
[[ -d "${ANTIGEN_CACHE_DIR}" ]] || mkdir -p "${ANTIGEN_CACHE_DIR}"
[[ -f "${ANTIGEN_DEBUG_LOG}" ]] || touch "${ANTIGEN_DEBUG_LOG}"

# Attempt Install...
if [[ ! -f "${ANTIGEN_BIN}" ]]; then
  echo "Antigen not found here: "${ANTIGEN_BIN}". Attempting Install..."
  git clone https://github.com/zsh-users/antigen.git "${ANTIGEN_REPO_DIR}"
fi

# Did it install correctly?
if [[ -f "${ANTIGEN_BIN}" ]]; then
  # Sometimes Antigen lock files get left around for whatever reason.
  # Let's clean those up.
  [[ -f "${ANTIGEN_LOCK}" ]] && rm -f "${ANTIGEN_LOCK}"

  source "${ANTIGEN_BIN}"
  antigen init "${XDG_CONFIG_HOME}/zsh/plugins"
else
  echo "WARNING: Antigen not found: ${ANTIGEN_BIN}. Skipping init."
fi

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

# ZSH Lazy-Loading
#-------------------------
# source "${XDG_CONFIG_HOME}/zsh/sandboxd"

# ZSH Completions
#-------------------------
if [[ -d "${XDG_CONFIG_HOME}/zsh/completions" ]]; then
  fpath=(
    ${XDG_CONFIG_HOME}/zsh/completions
    ${fpath}
  )
  if [[ "${OSTYPE}" == "*darwin*" ]]; then
    fpath=(
      ${PREFIX}/share/zsh/site-functions
      ${fpath}
    )
  fi
fi

# Add heroku completions - Linux.
if [[ "${OSTYPE}" == "*linux*" ]]; then
  HEROKU_AC_ZSH_SETUP_PATH="${XDG_CACHE_HOME}/heroku/autocomplete/zsh_setup"
  [[ -f "${HEROKU_AC_ZSH_SETUP_PATH}" ]] && source "${HEROKU_AC_ZSH_SETUP_PATH}"
fi

# Load completions and bash completions
autoload -Uz compinit && compinit -i -d "${ZCOMPDUMP}"
autoload -Uz bashcompinit && bashcompinit
