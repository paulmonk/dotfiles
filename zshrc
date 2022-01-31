#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# .zshrc is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# ZSH Plugins
#-------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ZSH Opts
#-------------------------
# When run after plugins some opts can be superseded here.
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/opts"


# Additional SH Settings
#-------------------------
source "${XDG_CONFIG_HOME:-$HOME/.config}/sh/aliases"
source "${XDG_CONFIG_HOME:-$HOME/.config}/sh/colors"
source "${XDG_CONFIG_HOME:-$HOME/.config}/sh/gpg-agent"


# ZSH Settings
#-------------------------
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/keybindings"
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliases"


# ZSH Functions
#-------------------------
# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
if [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions" ]]; then
  fpath=(
    ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/functions
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
if [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/commands" ]]; then
  for bin in ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/commands/*; do
    cmd=$(basename "${bin}")
    if (( $+commands[$cmd] )) && [[ -s "${bin}" ]]; then
      source "${bin}";
    fi
  done
  unset bin
fi


# ZSH Lazy-Loading
#-------------------------
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/sandboxd"


# ZSH Completions
#-------------------------
if [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions" ]]; then
  fpath=(
    ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions
    ${BREW_PREFIX}/share/zsh/site-functions
    ${fpath}
  )
fi

# macOS add gcloud completions
if [[ "${KERNEL}" == "Darwin" ]]; then
  GCLOUD_COMPLETIONS_SETUP_PATH="${BREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
  [[ -f "${GCLOUD_COMPLETIONS_SETUP_PATH}" ]] && source "${GCLOUD_COMPLETIONS_SETUP_PATH}"
fi

# Add heroku completions - Linux.
if [[ "${KERNEL}" == "Linux" ]]; then
  HEROKU_AC_ZSH_SETUP_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/heroku/autocomplete/zsh_setup"
  [[ -f "${HEROKU_AC_ZSH_SETUP_PATH}" ]] && source "${HEROKU_AC_ZSH_SETUP_PATH}"
fi

# zoxide
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# Load completions and bash completions
autoload -Uz +X compinit && compinit -i -d "${ZCOMPDUMP}"
autoload -Uz +X bashcompinit && bashcompinit

# Final: ZSH - Source any local overrides
#-------------------------
if [[ -f "${ZDOTDIR}/.zshrc.local" ]]; then
  source "${ZDOTDIR}/.zshrc.local"
fi
