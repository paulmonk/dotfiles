" ALE
" ------------------------------
let g:ale_sign_error = '!E'
let g:ale_sign_warning = '!W'
let g:ale_sign_info = 'ℹ'
"
" ------------------------------
" History
" ------------------------------
" Enable history
let g:ale_history_enabled = 1

" Ale will store output of commands which have completed succesfully.
let g:ale_history_log_output = 1

" How much history of commands to save.
let g:ale_max_buffer_history_size = 20

" ------------------------------
" Linting
" ------------------------------
" Whether lint on opening of a file
let g:ale_lint_on_enter = 0

" Whether to only enable the linters specified.
let g:ale_linters_explicit = 1

" Set the ale linters to use for specifc filetypes.
let g:ale_linters = {
\   'graphql': ['gqlint'],
\   'javascript': ['eslint'],
\   'html': ['tidy'],
\   'python': ['flake8', 'mypy', 'prospector'],
\   'sh': ['shellcheck']
\}

" Linter aliases
let g:ale_linter_aliases = {
\   'zsh': 'sh',
\   'csh': 'sh',
\   'htmldjango': 'html'
\}

" ------------------------------
" Fixers
" ------------------------------
" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 0

" Set the ale fixers for specfic filetypes
let g:ale_fixers = {
\   'graphql': ['prettier'],
\   'javascript': ['prettier'],
\   'json': ['prettier'],
\   'markdown': ['prettier'],
\   'python': ['isort', 'black'],
\   'sh': ['shfmt']
\}

" Do not lint or fix minified files.
let g:ale_pattern_options = {
\   '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\   '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\}
" If you configure g:ale_pattern_options outside of vimrc, you need this.
let g:ale_pattern_options_enabled = 1

" Dockerfile
"--------------
" If not installed locally, should we use the docker image available.
" options: 'never', 'always', 'maybe'.
" If 'maybe' then checks locally first and uses docker image as fallback.
let g:ale_dockerfile_hadolint_use_docker = 'maybe'

" GrpahQL
"--------------
let g:ale_graphql_prettier_use_global = 1
let g:ale_graphql_prettier_options = '--parser graphql'

" Javascript
"--------------
let g:ale_javascript_prettier_use_global = 1
let g:ale_javascript_prettier_options = '--single-quote --no-bracket-spacing'

" JSON
"--------------
let g:ale_json_prettier_use_global = 1
let g:ale_json_prettier_options = '--parser json5'

" Markdown
"--------------
let g:ale_markdown_prettier_use_global = 1
let g:ale_markdown_prettier_options = '--parser markdown'

" Python
"--------------
let g:ale_python_black_options = '--line-length 90 --skip-string-normalization'
let g:ale_python_flake8_options = '--max-line-length 90'

" Shell
"--------------
let g:ale_sh_shfmt_options = '-i 2 -ci'
