---
name: commit-push-pr
description: Commit, push, and open a PR in one step
allowed-tools: Bash(git checkout:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(gh pr create:*), Read, Glob
---

# Commit Push PR

Complete workflow that commits changes, pushes the branch,
and creates a pull request in one step.

## Usage

```text
/commit-push-pr
```

## Workflow

### 1. Gather Context

Run these commands in parallel:

| Command                     | Purpose                       |
| --------------------------- | ----------------------------- |
| `git status`                | See staged and unstaged files |
| `git diff HEAD`             | View all changes              |
| `git branch --show-current` | Check if on main/master       |
| `git log --oneline -10`     | Match existing commit style   |

### 2. Create Branch (if needed)

If currently on `main` or `master`:

- Create a new feature branch with a descriptive name
- Use `git checkout -b <branch-name>`

### 3. Stage and Commit

- Stage relevant files (prefer specific files over `git add -A`)
- Create commit with appropriate message following
  Conventional Commits

### 4. Push to Remote

- Push the branch to origin with tracking: `git push -u origin <branch>`

### 5. Find PR Template

Search for a PR template in the repository using Glob:

1. `**/*PULL_REQUEST_TEMPLATE*` (covers `.github/` and
   `.github/PULL_REQUEST_TEMPLATE/` locations)
2. If found, use `Read` to get its contents
3. If not found, use the default template from
   [./templates/pull-request.md](templates/pull-request.md)

### 6. Create Draft Pull Request

Use `gh pr create` with:

```bash
gh pr create --draft --title "<PR_TITLE>" --body "$(cat <<'EOF'
<TEMPLATE_BODY>
EOF
)"
```

Ensure you follow the guidance of the template to fill out
the PR appropriately. It may have guidance for the title
and body of the PR.

### 7. Return PR URL

Output the PR URL so the user can view it.

## Notes

- All steps should be completed in a single message using
  parallel tool calls where possible
- Do not use any other tools besides those listed
- Do not send any other text or messages besides tool calls
- Requires GitHub CLI (`gh`) to be installed and authenticated
