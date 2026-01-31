---
name: commit
description: Create a git commit with auto-generated message
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*)
---

# Commit

Create a git commit by analyzing staged and unstaged changes, then generating an appropriate commit message that matches the repository's style.

## Usage

```
/commit
```

## Workflow

### 1. Gather Context

Run these commands in parallel to understand the current state:

| Command                     | Purpose                          |
| --------------------------- | -------------------------------- |
| `git status`                | See staged and unstaged files    |
| `git diff HEAD`             | View all changes to be committed |
| `git branch --show-current` | Identify current branch          |
| `git log --oneline -10`     | Match existing commit style      |

### 2. Analyze Changes

- Identify what type of change this is (feat, fix, refactor, docs, test, chore)
- Determine the scope from affected files/directories
- Summarize the "why" not the "what"

### 3. Stage and Commit

In a single message with parallel tool calls:

1. Stage relevant files with `git add` (prefer specific files over `git add -A`)
2. Create the commit with an appropriate message (Run `git config --get commit.template` to get the commit template and use it)

### 4. Security Checks

Do NOT commit files that may contain secrets:

- `.env`, `.env.*`
- `credentials.json`, `secrets.*`
- `*.pem`, `*.key`

Warn the user if such files are staged.

## Notes

- Do not use any other tools besides those listed
- Do not send any other text or messages besides tool calls
- Match the repository's existing commit message style from git log
