---
name: commit-push-pr
description: Commit staged work, push, and open a draft PR/MR. Use when asked to commit and push, create a PR, or ship changes.
allowed-tools: Bash, Read, Glob, Grep
argument-hint: "[issue number or beads-ID]"
---

# Commit, Push, and Open PR

Commit the current changes, push the branch, and create a draft
PR/MR. This is the tail end of the fix-issue workflow, for when
the implementation and quality checks are already done.

## When to Use

- User asks to commit, push, and open a PR/MR
- Implementation and quality checks are done, time to ship
- Invoked by `/fix-issue` at the end of its workflow

## When NOT to Use

- Changes haven't been tested or reviewed yet
- User only wants to commit without pushing or creating a PR

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

If not found, use this default template:

```markdown
## Why are we changing this?

<!--- Make it easy to understand, write it for people outside your team. -->
<!--- Add any related stories/PRs that help give the reviewer context. -->

## What has changed?

<!--- You know the ins and out of the code, the reviewer might not. -->
<!--- Add any specific implementation details or anything non-obvious. -->

## How to test it and expected results?

<!--- Make it easy to test, give explicit step-by-step instructions. -->
<!--- Include screenshots or pastes of output so it's clear what to expect. -->

## Checklist

- [ ] My pull request represents one logical piece of work.
- [ ] My commits are related to the pull request and look clean.
- [ ] My code follows our coding conventions.
- [ ] My code has appropriate tests and documentation.
```

#### Create draft

Write the body to a unique temp file (avoids clobbering when
multiple agents run concurrently):

```bash
PR_BODY="${TMPDIR:-/tmp}/pr-body-$(date +%Y%m%d%H%M%S).md"
cat > "$PR_BODY" <<'EOF'
<TEMPLATE_BODY>
EOF
```

**GitHub:**

```bash
GH_PROMPT_DISABLED=1 GIT_TERMINAL_PROMPT=0 \
  gh pr create --draft \
    --title "<TITLE>" \
    --body-file "$PR_BODY" \
    --head "$(git branch --show-current)"
```

**GitLab:**

```bash
glab mr create --draft \
  --title "<TITLE>" \
  --description "$(cat "$PR_BODY")" \
  --source-branch "$(git branch --show-current)"
```

Title must be under 70 chars. Description should summarise the
changes and reference the issue if one was provided. Keep the description
concise but aligned with the template. Do NOT hard-wrap lines in the PR
description body. Write each sentence or bullet point as a single long
line and let the renderer handle wrapping.

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
