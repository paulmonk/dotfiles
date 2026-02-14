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

# Sync dotfiles symlinks only (no hooks, except dead symlink cleanup)
[group('dotfiles')]
dotfiles: rcup-install
    @echo "--------------------------------"
    @echo "Syncing dotfiles"
    @RCRC="{{ justfile_directory() }}/config/rcm/rcrc" PATH="{{ default_path }}" {{ prefix }}/bin/rcup -d {{ justfile_directory() }} -K -f -v
    @echo "--------------------------------"
    @echo "Removing Broken Symlinks"
    @{{ justfile_directory() }}/hooks/post-up/99-remove-broken-symlinks
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

# Configure coding agent tools (Claude Code, Codex, OpenCode)
[group('tools')]
coding-agents: qmd
    #!/usr/bin/env bash
    set -euo pipefail
    echo "--------------------------------"

    # Claude Code MCP servers
    echo "Configuring Claude Code MCP servers"
    echo "  Ensuring gh_grep"
    claude mcp add-json --scope user gh_grep '{"type":"http","url":"https://mcp.grep.app"}' >/dev/null 2>&1 || true
    echo "  Ensuring context7"
    claude mcp add --scope user context7 -- npx -y @upstash/context7-mcp >/dev/null 2>&1 || true
    echo "  Ensuring exa"
    claude mcp add --scope user exa -- npx -y exa-mcp-server -e EXA_API_KEY >/dev/null 2>&1 || true
    echo "  Ensuring firecrawl"
    claude mcp add --scope user firecrawl -- npx -y firecrawl-mcp -e FIRECRAWL_API_KEY >/dev/null 2>&1 || true
    echo "  Ensuring chrome-devtools"
    claude mcp add --scope user chrome-devtools -- npx -y chrome-devtools-mcp >/dev/null 2>&1 || true
    echo "  Ensuring deepwiki"
    claude mcp add --scope user -t http deepwiki https://mcp.deepwiki.com/mcp >/dev/null 2>&1 || true
    if [[ -n "${BUN_INSTALL_BIN:-}" ]]; then
      echo "  Ensuring qmd"
      # Blank BUN_INSPECT_CONNECT_TO so Cursor's injected debug socket doesn't hang bun.
      claude mcp add --scope user -e BUN_INSPECT_CONNECT_TO= qmd -- "${BUN_INSTALL_BIN}/qmd" mcp >/dev/null 2>&1 || true
    else
      echo "  [warn] BUN_INSTALL_BIN not set; skipping qmd MCP server" >&2
    fi

    # Worktrunk
    echo "Configuring worktrunk"
    if command -v wt >/dev/null 2>&1; then
      wt config shell install 2>/dev/null || true
    else
      echo "  [warn] worktrunk not installed; skipping" >&2
    fi

    # Codex: generate AGENTS.md from Claude Code sources
    echo "Generating Codex AGENTS.md"
    if [[ ! -f claude/CLAUDE.md ]]; then
      echo "Error: claude/CLAUDE.md not found" >&2
      exit 1
    fi
    {
      echo '<!-- Generated by: just coding-agents -->'
      echo '<!-- Source: claude/CLAUDE.md + claude/rules/*.md -->'
      echo '<!-- Do not edit directly -->'
      echo
      cat claude/CLAUDE.md
      for f in claude/rules/*.md; do
        [[ -f "$f" ]] || continue
        echo
        # Strip YAML frontmatter and demote headings so only
        # CLAUDE.md keeps the top-level H1 (fixes MD025)
        awk '
          BEGIN { fm = 0 }
          /^---$/ { fm++; if (fm <= 2) next }
          fm >= 2 || fm == 0 {
            if (/^#/) print "#" $0; else print
          }
        ' "$f"
      done
    } | awk '/^$/{if(b)next;b=1;print;next}{b=0;print}' > codex/AGENTS.md

    # OpenCode and Codex: MCP and instructions are declarative in config files
    echo "Done."
    echo "--------------------------------"

# Full install of all components
[group('tools')]
install:
    @echo "--------------------------------"
    @just dotfiles-bootstrap
    @just coding-agents
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
    @rumdl check .
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
    @rumdl fmt .
    @echo "--------------------------------"
