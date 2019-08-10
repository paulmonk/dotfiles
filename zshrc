#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# .zshrc is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Plugins
#-------------------------
# Load antigen
# https://github.com/zsh-users/antigen/wiki/Configuration
export ADOTDIR="${XDG_DATA_HOME}/zsh/antigen"
export ANTIGEN_BUNDLES="${ADOTDIR}/bundles"

# Note: These non export-vars below are not official exports
_ANTIGEN_CACHE_DIR="${XDG_CACHE_HOME}/zsh/antigen"
_ANTIGEN_REPO_DIR="${ADOTDIR}/repo"
_ANTIGEN_BIN="${_ANTIGEN_REPO_DIR}/antigen.zsh"

export ANTIGEN_CACHE="${_ANTIGEN_CACHE_DIR}/init.zsh"
export ANTIGEN_COMPDUMP="${_ANTIGEN_CACHE_DIR}/compdump-${HOST}-${ZSH_VERSION}"
export ANTIGEN_DEBUG_LOG="${_ANTIGEN_CACHE_DIR}/debug.log"
export ANTIGEN_LOCK="${_ANTIGEN_CACHE_DIR}/lock"

# Create antigen dirs/files if they do not exist.
[[ -d "${ADOTDIR}" ]] || mkdir -p "${ADOTDIR}"
[[ -d "${_ANTIGEN_CACHE_DIR}" ]] || mkdir -p "${_ANTIGEN_CACHE_DIR}"
[[ -f "${ANTIGEN_DEBUG_LOG}" ]] || touch "${ANTIGEN_DEBUG_LOG}"

# Attempt Install...
if [[ ! -f "${_ANTIGEN_BIN}" ]]; then
  echo "Antigen not found here: "${_ANTIGEN_BIN}". Attempting Install..."
  git clone https://github.com/zsh-users/antigen.git "${_ANTIGEN_REPO_DIR}"
fi

# Did it install correctly?
if [[ -f "${_ANTIGEN_BIN}" ]]; then
  # Sometimes Antigen lock files get left around for whatever reason.
  # Let's clean those up.
  [[ -f "${ANTIGEN_LOCK}" ]] && rm -f "${ANTIGEN_LOCK}"

  source "${_ANTIGEN_BIN}"
  antigen init "${XDG_CONFIG_HOME}/zsh/plugins"
else
  echo "WARNING: Antigen not found: ${_ANTIGEN_BIN}. Skipping init."
fi

# Opts
#-------------------------
# When run after plugins some opts can be superseded here.
source "${XDG_CONFIG_HOME}/zsh/opts"


# SH Settings
#-------------------------
source "${XDG_CONFIG_HOME}/sh/aliases"
source "${XDG_CONFIG_HOME}/sh/colors"
source "${XDG_CONFIG_HOME}/sh/gpg-agent"


# ZSH Settings
#-------------------------
source "${XDG_CONFIG_HOME}/zsh/keybindings"
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
unset func


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
  unset bin
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
  if [[ "${KERNEL}" == "Darwin" ]]; then
    fpath=(
      ${PREFIX}/share/zsh/site-functions
      ${fpath}
    )
  fi
fi

# Add heroku completions - Linux.
if [[ "${KERNEL}" == "Linux" ]]; then
  HEROKU_AC_ZSH_SETUP_PATH="${XDG_CACHE_HOME}/heroku/autocomplete/zsh_setup"
  [[ -f "${HEROKU_AC_ZSH_SETUP_PATH}" ]] && source "${HEROKU_AC_ZSH_SETUP_PATH}"
fi

# Load completions and bash completions
# autoload -Uz compinit && compinit -i -d "${ZCOMPDUMP}"
# autoload -Uz bashcompinit && bashcompinit


# ZSH - Source any local overrides
#-------------------------
if [[ -f "${ZDOTDIR}/zshrc.local" ]]; then
  source "${ZDOTDIR}/zshrc.local"
fi
