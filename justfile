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
[group('tools')]
qmd:
    @echo "--------------------------------"
    @echo "Installing qmd"
    @bun install -g https://github.com/tobi/qmd
    @echo "--------------------------------"

# Load the qmd LaunchAgent
[group('tools')]
qmd-agent-load:
    @launchctl load ~/Library/LaunchAgents/local.qmd.update.plist

# Unload the qmd LaunchAgent
[group('tools')]
qmd-agent-unload:
    @launchctl unload ~/Library/LaunchAgents/local.qmd.update.plist

# Setup Claude Code MCP servers
[group('tools')]
claude-code-mcp: qmd
    @echo "--------------------------------"
    @echo "Configuring Claude Code MCP servers"
    @echo "  Ensuring github"
    @claude mcp add-json --scope user github '{"type":"http","url":"https://api.githubcopilot.com/mcp/","headers":{"Authorization":"Bearer '"${GITHUB_PERSONAL_ACCESS_TOKEN}"'"}}' >/dev/null 2>&1 || true
    @echo "  Ensuring aws-knowledge"
    @claude mcp add-json --scope user aws-knowledge '{"type":"http","url":"https://knowledge-mcp.global.api.aws"}' >/dev/null 2>&1 || true
    @echo "  Ensuring gcloud"
    @claude mcp add --scope user gcloud -- npx -y @google-cloud/gcloud-mcp >/dev/null 2>&1 || true
    @echo "  Ensuring huggingface"
    @claude mcp add --scope user huggingface -- npx -y hf-mcp-server -t http "https://huggingface.co/mcp?login" >/dev/null 2>&1 || true
    @echo "  Ensuring atlassian"
    @claude mcp add --scope user atlassian -- npx -y mcp-remote https://mcp.atlassian.com/v1/sse >/dev/null 2>&1 || true
    @echo "  Ensuring firecrawl"
    @claude mcp add --scope user firecrawl -- npx -y firecrawl-mcp -e FIRECRAWL_API_KEY >/dev/null 2>&1 || true
    @echo "  Ensuring chrome-devtools"
    @claude mcp add --scope user chrome-devtools -- npx -y chrome-devtools-mcp >/dev/null 2>&1 || true
    @echo "  Ensuring qmd"
    @claude mcp add --scope user qmd -- ${BUN_INSTALL_BIN}/bin/qmd mcp >/dev/null 2>&1 || true
    @echo "Done."
    @echo "--------------------------------"

# Full install of all components
[group('tools')]
install:
    @echo "--------------------------------"
    @just dotfiles-bootstrap
    @just claude-code-mcp
    @just qmd-agent-load
    @echo "--------------------------------"

# ================================
# Development
# ================================

# Lint scripts
[group('dev')]
lint:
    @echo "--------------------------------"
    @echo "Linting shell scripts"
    @shfmt --apply-ignore --find . | xargs shellcheck
    @echo "Linting Lua scripts"
    @selene .
    @echo "Linting Markdown files"
    @markdownlint-cli2 "**/*.md"
    @echo "--------------------------------"

# Format scripts
[group('dev')]
format:
    @echo "--------------------------------"
    @echo "Formatting shell scripts"
    @shfmt --write --apply-ignore .
    @echo "Formatting Lua scripts"
    @stylua .
    @echo "Formatting Markdown files"
    @prettier --write "**/*.md"
    @echo "--------------------------------"
