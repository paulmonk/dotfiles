# Dotfiles Repository

This repository contains personal dotfiles and configuration for
development tools, managed with
[rcm](https://github.com/thoughtbot/rcm).

## What This Is

A dotfiles repository, not application code. Files here are
symlinked to `$HOME` for shell, editor, and tool configuration.

## Structure

| Directory  | Purpose                                           |
| ---------- | ------------------------------------------------- |
| `config/`  | XDG config files (git, tmux, zsh, opencode, etc.) |
| `claude/`  | Claude Code configuration (see below)             |
| `codex/`   | Codex configuration (generated AGENTS.md, rules)  |
| `gemini/`  | Gemini CLI configuration (settings, GEMINI.md)    |
| `Library/` | macOS application preferences                     |
| `local/`   | Local bin scripts and data                        |

### Claude Code (`claude/`)

| Directory    | Purpose                                            |
| ------------ | -------------------------------------------------- |
| `commands/`  | Slash commands: explicit user-invoked actions       |
| `skills/`    | Skills: domain knowledge auto-triggered by context  |
| `agents/`    | Subagent definitions (used by commands/skills)      |
| `hooks/`     | Event hooks (PreToolUse, PostToolUse)               |
| `rules/`     | Path-scoped and global rules                        |

**Commands vs skills**: commands are procedural recipes the user
triggers explicitly (`/changelog`, `/fix-issue`). Skills are
guidance and domain knowledge Claude picks up automatically when
the conversation matches (cloud-pricing, investigation,
research). If something has `disable-model-invocation: true`, it
belongs in `commands/`.

## Worktree Policy

When `.worktrees/` exists for this repo, make edits from a worktree
path (for example `.../.worktrees/<branch>/...`) rather than the main
checkout.

If `.worktrees/` does not exist yet, working in the main checkout is
allowed.

## Usage

Recipes are defined in the `justfile` to manage dotfiles, dependencies, and
lint/format the files.
