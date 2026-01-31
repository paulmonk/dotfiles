# ================================
# Configuration
# ================================

# Use bash with strict mode
set shell := ["bash", "-euo", "pipefail", "-c"]

# Show available recipes when no argument given
default:
    @just --list

# Env vars
prefix := "/opt/homebrew"
default_path := prefix / "bin:/usr/bin:/bin:/usr/sbin:/sbin"
xdg_config_home := env("XDG_CONFIG_HOME", env("HOME") / ".config")
xdg_cache_home := env("XDG_CACHE_HOME", env("HOME") / ".cache")
xdg_data_home := env("XDG_DATA_HOME", env("HOME") / ".local/share")

export XDG_CONFIG_HOME := xdg_config_home
export XDG_CACHE_HOME := xdg_cache_home
export XDG_DATA_HOME := xdg_data_home

# ================================
# Homebrew
# ================================

# Install Homebrew if not present
[group('homebrew')]
brew-install:
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -x "{{ prefix }}/bin/brew" ]]; then
        exit 0
    fi
    just _brew-install-confirm

[private]
[confirm("Homebrew will be installed via shell script. Please audit https://raw.githubusercontent.com/Homebrew/install/master/install.sh first. Continue?")]
_brew-install-confirm:
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install packages from Brewfile
[group('homebrew')]
brew-bundle: brew-install
    @echo "--------------------------------"
    @echo "Installing Homebrew Bundle"
    @{{ prefix }}/bin/brew bundle --cleanup --quiet --verbose --zap
    @echo "--------------------------------"

# Dump current packages to Brewfile
[group('homebrew')]
brew-bundle-dump:
    @echo "--------------------------------"
    @echo "Dumping Brewfile"
    @{{ prefix }}/bin/brew bundle dump --describe --force --verbose --no-restart
    @echo "--------------------------------"

# ================================
# Dotfiles
# ================================

# Ensure rcup is installed
[private]
rcup-install: brew-install
    @{{ prefix }}/bin/brew install --quiet rcm

# Sync dotfiles symlinks only (no hooks)
[group('dotfiles')]
dotfiles: rcup-install
    @echo "--------------------------------"
    @echo "Syncing dotfiles"
    @RCRC="{{ justfile_directory() }}/config/rcm/rcrc" PATH="{{ default_path }}" {{ prefix }}/bin/rcup -d {{ justfile_directory() }} -K -f -v
    @echo "--------------------------------"

# Bootstrap dotfiles with pre and post hooks
[group('dotfiles')]
dotfiles-bootstrap: rcup-install
    @echo "--------------------------------"
    @echo "Bootstrapping dotfiles"
    @RCRC="{{ justfile_directory() }}/config/rcm/rcrc" PATH="{{ default_path }}" {{ prefix }}/bin/rcup -d {{ justfile_directory() }} -k -f -v
    @echo "--------------------------------"

# ================================
# Tools
# ================================

# Setup Claude Code MCP servers
[group('tools')]
claude-code-mcp:
    @echo "--------------------------------"
    @echo "Adding Claude Code MCP servers"
    @claude mcp add-json --scope user github '{"type":"http","url":"https://api.githubcopilot.com/mcp/","headers":{"Authorization":"Bearer ${GITHUB_TOKEN}"}}'
    @claude mcp add --scope user atlassian -- npx -y mcp-remote https://mcp.atlassian.com/v1/sse
    @claude mcp add --scope user firecrawl -- npx -y firecrawl-mcp -e FIRECRAWL_API_KEY
    @claude mcp add --scope user qmd -- ${BUN_INSTALL_BIN}/bin/qmd mcp
    @echo "MCP servers configured. Set GITHUB_TOKEN env var for GitHub MCP."
    @echo "--------------------------------"

# Full install of all components
[group('tools')]
install: brew-bundle dotfiles-bootstrap
    @echo "--------------------------------"
    @bun install -g https://github.com/tobi/qmd
    @just claude-code-mcp
    @echo "--------------------------------"

# ================================
# Development
# ================================

# Lint shell scripts
[group('dev')]
lint:
    @echo "--------------------------------"
    @echo "Linting Shell scripts"
    @shfmt --apply-ignore --find . | xargs shellcheck
    @echo "--------------------------------"

# Format shell scripts
[group('dev')]
format:
    @echo "--------------------------------"
    @echo "Formatting Shell scripts"
    @shfmt --write --apply-ignore .
    @echo "--------------------------------"
