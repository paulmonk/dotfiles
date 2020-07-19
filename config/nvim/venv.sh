#!/usr/bin/env bash

_try_pyenv() {
    local name='' src='' python_version=''
    if hash pyenv 2>/dev/null; then
        echo '===> pyenv found, searching virtualenvs...'
        name="neovim"
        src="$(pyenv prefix "${name}" 2>/dev/null)"
        if [ -d "${src}" ]; then
            echo "===> pyenv virtualenv found '${name}'"
        else
            echo "===> pyenv virtualenv not found, creating... '${name}'"
            python_version="3.7.7"
            pyenv install "${python_version}"
            pyenv virtualenv "${python_version}" neovim
        fi
        # Symlink virtualenv for easy access
        src="$(pyenv prefix "${name}")"
        ln -fs "${src}" "${__venv}"
        return 0
    else
        echo '===> pyenv not found, skipping'
    fi
    return 1
}

_try_python() {
    if ! hash python3 2>/dev/null; then
        echo '===> python3 not found, skipping'
        return 1
    fi
    echo "===> python3 found"
    [ -d "${__venv}" ] || python3 -m venv "${__venv}"
}

main() {
    # Concat a base path for vim cache and virtual environment
    local __cache="${XDG_CACHE_HOME:-$HOME/.cache}/vim"
    local __venv="${__cache}/venv"
    mkdir -p "${__cache}"

    if _try_pyenv || _try_python; then
        # Install Python 3 requirements
        "${__venv}/bin/pip" install -U pynvim PyYAML Send2Trash
        echo '===> success'
    else
        echo '===> ERROR: unable to setup python3 virtualenv.'
        echo -e '\nConsider using pyenv with its virtualenv plugin:'
        echo '- https://github.com/pyenv/pyenv'
        echo '- https://github.com/pyenv/pyenv-virtualenv'
        exit 1
    fi
}

main
