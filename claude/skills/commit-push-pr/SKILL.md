---
name: commit-push-pr
description: Commit staged work, push, and open a draft PR/MR. Use after implementation is complete and tests pass.
allowed-tools: Bash, Read, Glob, Grep
argument-hint: "<optional: issue number or beads-ID to reference>"
disable-model-invocation: true
---

# Commit, Push, and Open PR

Commit the current changes, push the branch, and create a draft
PR/MR. This is the tail end of the fix-issue workflow, for when
the implementation and quality checks are already done.

## Arguments

`$ARGUMENTS`: optional issue number or beads ID to reference in
the commit message and PR body. If omitted, the commit and PR
are created without an issue reference.

## Workflow

Execute every step sequentially. Do not stop or ask for
confirmation at any step.

### 1. Detect Forge

Run in parallel:

```bash
git remote get-url origin
git branch --show-current
```

| Remote pattern         | Forge  | CLI    | PR command       |
| ---------------------- | ------ | ------ | ---------------- |
| `github.com`           | GitHub | `gh`   | `gh pr create`   |
| `gitlab.com` or custom | GitLab | `glab` | `glab mr create` |

Store the forge, CLI, and terminology (PR vs MR) for later
steps.

### 2. Gather Context

Run in parallel:

```bash
git status
git diff --cached --stat
git diff --stat
git log --oneline -10
```

Review the output. If nothing is staged and there are unstaged
changes, stage the relevant files (prefer specific files over
`git add -A`). Do NOT stage files that may contain secrets
(`.env`, `credentials.json`, `*.pem`, `*.key`).

If there are no changes at all, stop and report that there is
nothing to commit.

### 3. Commit

#### Commit message format

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

- Format: `<type>(<scope>): <description>`
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
- Subject: lowercase after type, present tense, 50 chars max
- Blank line between subject and body
- Body: wrap at 72 chars, explain the why not the what
- If `$ARGUMENTS` was provided, add `Closes #N` or
  `Closes <beads-id>` in the body

If the project has a commit template
(`git config --get commit.template`), follow it.

Create the commit using a heredoc:

```bash
git commit -m "$(cat <<'EOF'
<type>(<scope>): <description>

<body>
EOF
)"
```

### 4. Push

Push with tracking:

```bash
git push -u origin $(git branch --show-current)
```

If the push fails due to workflow auth errors or diverged
history, pull and retry:

```bash
git pull origin $(git branch --show-current) --rebase && git push -u origin $(git branch --show-current)
```

### 5. Create PR/MR

#### Find template

Search for a PR/MR template in the repository:

**GitHub:** `**/*PULL_REQUEST_TEMPLATE*`

**GitLab:**
`**/.gitlab/merge_request_templates/*` or
`.gitlab/merge_request_templates/Default.md`

If not found, use the default template from
[./templates/pull-request.md](templates/pull-request.md).
If that also doesn't exist, use a simple format:

```markdown
## Why

<one-paragraph summary>

## What changed

<bullet list of changes>
```

#### Create draft

Write the body to a temp file to preserve formatting:

```bash
cat > /tmp/ai-agent/pr-body.md <<'EOF'
<TEMPLATE_BODY>
EOF
```

**GitHub:**

```bash
GH_PROMPT_DISABLED=1 GIT_TERMINAL_PROMPT=0 \
  gh pr create --draft \
    --title "<TITLE>" \
    --body-file /tmp/ai-agent/pr-body.md \
    --head "$(git branch --show-current)"
```

**GitLab:**

```bash
glab mr create --draft \
  --title "<TITLE>" \
  --description "$(cat /tmp/ai-agent/pr-body.md)" \
  --source-branch "$(git branch --show-current)"
```

Title must be under 70 chars. Description should summarise the
changes and reference the issue if one was provided.

### 6. Link Back to Issue (if applicable)

If `$ARGUMENTS` identified a beads issue, close it:

```bash
bd close <id> --reason="Fixed in PR/MR <url>"
```

For forge issues, the `Closes #N` in the commit/PR body handles
linking automatically.

### 7. Return Result

Output the PR/MR URL so the user can view it.

## Notes

- Use parallel tool calls where possible (e.g. step 1 and 2)
- Requires `gh` (GitHub) or `glab` (GitLab) to be installed
  and authenticated
