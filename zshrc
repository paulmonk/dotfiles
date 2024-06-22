#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# .zshrc is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ZSH Functions
#-------------------------
# See: https://github.com/mattmc3/zfunctions/tree/main
export ZFUNCDIR="${XDG_CONFG_HOME:-$HOME/.config}/zsh/functions"

# ZSH Plugins
#-------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source antidote
if [[ "${KERNEL}" == "Darwin" ]]; then
    source "${PREFIX}/opt/antidote/share/antidote/antidote.zsh"
else
    git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-$HOME}/.antidote
fi

# initialize plugins statically
antidote load ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins

# Powerlevel10k
autoload -Uz promptinit && promptinit && prompt powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

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

# Load completions and bash completions
autoload -Uz +X compinit && compinit -i -d "${ZCOMPDUMP}"
autoload -Uz +X bashcompinit && bashcompinit

# Loading...
#-------------------------
# zoxide
if (( $+commands[zoxide] )); then
    _ZO_DATA="${XDG_DATA_HOME}/zsh/zo"
    [[ ! -f "${_ZO_DATA}" ]] && touch "${_ZO_DATA}"
    export _ZO_DATA
    eval "$(zoxide init zsh)"
fi

# Shell history
if (( $+commands[atuin] )); then
    eval "$(atuin init zsh)"
fi

# Final: ZSH - Source any local overrides
#-------------------------
if [[ -f "${ZDOTDIR}/.zshrc.local" ]]; then
    source "${ZDOTDIR}/.zshrc.local"
fi
