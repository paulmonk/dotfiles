---
name: clean-branches
description: Clean up local branches deleted from remote, including worktrees
allowed-tools: Bash(git branch:*), Bash(git worktree:*)
---

# Clean Branches

Clean up stale local branches that have been deleted from the remote repository, including any associated git worktrees.

## Usage

```
/clean-branches
```

## Workflow

### 1. List Branches

Identify branches with `[gone]` status:

```bash
git branch -v
```

Note: Branches with a `+` prefix have associated worktrees that must be removed first.

### 2. List Worktrees

Identify worktrees that may need removal:

```bash
git worktree list
```

### 3. Remove Worktrees and Delete Branches

Process all `[gone]` branches:

```bash
git branch -v | grep '\[gone\]' | sed 's/^[+* ]//' | awk '{print $1}' | while read branch; do
  echo "Processing branch: $branch"
  # Find and remove worktree if it exists
  worktree=$(git worktree list | grep "\\[$branch\\]" | awk '{print $1}')
  if [ ! -z "$worktree" ] && [ "$worktree" != "$(git rev-parse --show-toplevel)" ]; then
    echo "  Removing worktree: $worktree"
    git worktree remove --force "$worktree"
  fi
  # Delete the branch
  echo "  Deleting branch: $branch"
  git branch -D "$branch"
done
```

### 4. Report Results

After execution, report:

- List of worktrees removed
- List of branches deleted
- Or "No cleanup needed" if no `[gone]` branches found

## Notes

- Safe to run anytime after merging PRs
- Only affects branches where remote tracking branch no longer exists
- Worktrees are removed before their associated branches
- Does not affect branches that still have remote tracking
