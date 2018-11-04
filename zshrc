#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# .zshrc is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Opts
#-------------------------
[[ -s "${XDG_CONFIG_HOME}/zsh/opts" ]] && source "${XDG_CONFIG_HOME}/zsh/opts"


# Plugins
#-------------------------
# Load antigen
if [[ -s "${XDG_CONFIG_HOME}/zsh/plugins" ]]; then
  # Antigen
  export ADOTDIR="${XDG_DATA_HOME}/zsh/antigen"
  export ANTIGEN_BUNDLES="${XDG_DATA_HOME}/zsh/antigen/bundles"
  export ANTIGEN_CACHE="${XDG_CACHE_HOME}/zsh/antigen/init.zsh"
  export ANTIGEN_COMPDUMP="${XDG_CACHE_HOME}/zsh/antigen/compdump-${HOST}-${ZSH_VERSION}"

  # Create antigen dirs/files if they do not exist.
  [[ -d "${XDG_CACHE_HOME}/zsh/antigen/" ]] || mkdir -p "${XDG_CACHE_HOME}/zsh/antigen/"
  [[ -d "${XDG_DATA_HOME}/zsh/antigen/" ]] || mkdir -p "${XDG_DATA_HOME}/zsh/antigen/"
  [[ -f "${XDG_DATA_HOME}/zsh/antigen/debug.log" ]] || touch "${XDG_DATA_HOME}/zsh/antigen/debug.log"

  antigen_repo_dir="${ADOTDIR}/repo"
  antigen_init_file="${antigen_repo_dir}/antigen.zsh"
  antigen_status=1
  if [[ ! -f "${antigen_init_file}" ]]; then
    git clone https://github.com/zsh-users/antigen.git "${antigen_repo_dir}" || antigen_status=0
  fi
  if [[ ${antigen_status} == 1 ]]; then
    source "${antigen_init_file}"
    antigen init "${XDG_CONFIG_HOME}/zsh/plugins"
  else
    echo "Antigen install failed, no plugins available."
  fi
fi


# Sh
#-------------------------
[[ -s "${XDG_CONFIG_HOME}/sh/aliases" ]] && source "${XDG_CONFIG_HOME}/sh/aliases"
[[ -s "${XDG_CONFIG_HOME}/sh/colors" ]] && source "${XDG_CONFIG_HOME}/sh/colors"
[[ -s "${XDG_CONFIG_HOME}/sh/gpg-agent" ]] && source "${XDG_CONFIG_HOME}/sh/gpg-agent"


# ZSH Keybindings
#-------------------------
[[ -s "${XDG_CONFIG_HOME}/zsh/keybindings" ]] && source "${XDG_CONFIG_HOME}/zsh/keybindings"


# ZSH Aliases
#-------------------------
[[ -s "${XDG_CONFIG_HOME}/zsh/aliases" ]] && source "${XDG_CONFIG_HOME}/zsh/aliases"


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


# ZSH Completions
#-------------------------
if [[ -d "${XDG_CONFIG_HOME}/zsh/completions" ]]; then
  fpath=(
    ${XDG_CONFIG_HOME}/zsh/completions
    ${fpath}
  )
  if [[ "$(uname -s)" == "Darwin" ]]; then
    fpath=(
      ${PREFIX}/share/zsh/site-functions
      ${fpath}
    )
  fi
fi

# Load completions and bash completions
autoload -Uz compinit && compinit -i -d "${ZCOMPDUMP}"
autoload -Uz bashcompinit && bashcompinit
