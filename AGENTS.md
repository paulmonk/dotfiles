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
| `claude/`  | Claude Code configuration (skills, agents, rules) |
| `codex/`   | Codex configuration (generated AGENTS.md, rules)  |
| `Library/` | macOS application preferences                     |
| `local/`   | Local bin scripts and data                        |

## Usage

Recipes are defined in the `justfile` to manage dotfiles, dependencies, and
lint/format the files.
