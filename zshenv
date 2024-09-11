#!/usr/bin/env zsh

#------------------------------------------------------------------------------
# This file contains most of our environment exports.
#------------------------------------------------------------------------------
# Don't load default zshrc
unsetopt GLOBAL_RCS

# Dump all aliases before load.
unalias -m '*'

# Source exports.
if [[ -s "${HOME}/.config/sh/exports" ]]; then
    source "${HOME}/.config/sh/exports"

    # ZSH Exports
    export ZCOMPDUMP="${XDG_CACHE_HOME}/zsh/compdump-${HOST}-${ZSH_VERSION}"
    export ZDOTDIR="${HOME}"

    # See: https://github.com/mattmc3/zfunctions/tree/main
    export ZFUNCDIR="${XDG_CONFG_HOME:-$HOME/.config}/zsh/functions"
fi

# macOS add gcloud CLI to PATH
if [[ "${KERNEL}" == "Darwin" ]]; then
    GCLOUD_SETUP_PATH="${BREW_PREFIX}/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    [[ -f "${GCLOUD_SETUP_PATH}" ]] && source "${GCLOUD_SETUP_PATH}"
fi

# Autoloads
# ============
# Asdf
if (( $+commands[asdf] )); then
    if [[ -s "${ASDF_DATA_DIR:-$BREW_PREFIX/opt/asdf}/asdf.sh" ]]; then
        source "${ASDF_DATA_DIR:-$BREW_PREFIX/opt/asdf}/asdf.sh"
    fi
elif (( $+commands[mise] )); then
        eval "$(mise activate zsh)"
else
    # Pyenv
    if (( $+commands[pyenv] )); then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi
fi

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
