---
name: fix-issue
description: End-to-end workflow to plan, implement, test, review, commit, push, and open a PR/MR for an issue
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, Task, Skill
argument-hint: "<issue-number, beads-ID, or URL>"
disable-model-invocation: true
---

# Fix Issue

End-to-end workflow: read an issue, plan, implement, test,
review, commit, push, and create a PR/MR.

## Arguments

`$ARGUMENTS`: issue number, beads ID, or URL.

## Workflow

Execute every step sequentially. Do not stop or ask for
confirmation at any step.

### 1. Detect Issue Source

Determine where the issue lives from the argument format:

| Argument pattern               | Source | Command               |
| ------------------------------ | ------ | --------------------- |
| Beads ID (e.g. `beads-abc`)    | Beads  | `bd show <id>`        |
| Project prefix (e.g. `DOT-1`) | Beads  | `bd show <id>`        |
| Number and `.beads/` exists    | Beads  | `bd show <number>`    |
| Number (no `.beads/`)          | Forge  | `gh/glab issue view`  |
| `#<number>`                    | Forge  | `gh/glab issue view`  |
| GitHub/GitLab URL              | Forge  | Parse, then CLI view  |

When the source is beads, also mark the issue in progress:

```bash
bd update <id> --status=in_progress
```

### 2. Detect Forge

Run in parallel:

```bash
git remote get-url origin
git branch --show-current
git fetch origin
```

| Remote pattern         | Forge  | CLI    | PR command       | Issue command      |
| ---------------------- | ------ | ------ | ---------------- | ------------------ |
| `github.com`           | GitHub | `gh`   | `gh pr create`   | `gh issue view`    |
| `gitlab.com` or custom | GitLab | `glab` | `glab mr create` | `glab issue view`  |

Store the forge, CLI, and terminology (PR vs MR) for later
steps.

### 3. Read Issue

Fetch full context from the detected source. Understand the
problem description, acceptance criteria, linked PRs, and any
discussion. Follow linked issues and external documentation to
build complete understanding before planning.

### 4. Research (if needed)

If the issue involves unfamiliar APIs, libraries, error
messages, or domain concepts, search for official documentation
and known solutions. Use the MCP tools configured in CLAUDE.md
(exa for web search, context7 for library docs, firecrawl for
page content).

Skip this step when the fix is clear from the codebase alone.

### 5. Plan

Write a plan to `.claude/plans/fix-<issue-id>.md`:

- Summarise the issue requirements
- List every file to create or modify
- Describe the approach and key design decisions
- Call out risks or open questions
- Reference relevant code paths by file:line

### 6. Create Branch

Create a branch from the default branch with a conventional
prefix based on the issue type:

| Type          | Prefix       |
| ------------- | ------------ |
| Bug           | `fix/`       |
| Feature       | `feat/`      |
| Refactor      | `refactor/`  |
| Documentation | `docs/`      |
| Maintenance   | `chore/`     |
| Ambiguous     | `fix/`       |

```bash
git checkout -b <prefix>/issue-<id>
```

### 7. Implement

Implement the plan across all necessary files. Follow the
project's CLAUDE.md and language rules. Keep changes minimal
and focused on the issue requirements.

Write tests alongside the implementation as part of the same
step.

When stuck, search for solutions rather than spinning.

### 8. Quality Pipeline

#### 8a. Discover project checks (CI is the source of truth)

Before running anything, read the project's CI configuration:

1. **Read CI workflows.** Scan `.github/workflows/` (or
   `.gitlab-ci.yml`) for the main CI workflow. Extract test
   commands with flags, lint/format commands, and any codegen
   sync checks (`git diff --exit-code` after a command).
2. **Read justfile or Makefile** (if present). Cross-reference
   targets used in CI.
3. **Read CLAUDE.md** for project-specific quality gates.

CI-discovered commands override the fallback tables below.

#### 8b. Run the quality pipeline

Detect the project language from manifest files. A project may
use multiple languages; run checks for each. If a tool is not
installed, skip it with a note.

Run in this order:

1. **Build** (compile or bundle)
2. **Test** (full suite with CI flags, iterate until green)
3. **Lint and format** (fix any issues)
4. **Type check** (if applicable)
5. **Codegen sync** (if discovered: run command, verify
   `git diff --exit-code`)

#### Fallback defaults

**Go** (`go.mod`):

| Step    | Command                                                        |
| ------- | -------------------------------------------------------------- |
| Build   | `go build ./...`                                               |
| Test    | `go test ./...`                                                |
| Lint    | `go vet ./...` then `staticcheck ./...` then `revive ./...`   |
| Format  | `gofmt -w .`                                                   |

**Python** (`pyproject.toml`):

| Step    | Command                                                        |
| ------- | -------------------------------------------------------------- |
| Sync    | `uv sync`                                                      |
| Test    | `uv run pytest -q`                                             |
| Lint    | `uv run ruff check --fix`                                      |
| Format  | `uv run ruff format`                                           |
| Types   | `uv run ty check` (fallback: `uv run mypy`)                   |

**Rust** (`Cargo.toml`):

| Step    | Command                                                        |
| ------- | -------------------------------------------------------------- |
| Build   | `cargo build`                                                  |
| Test    | `cargo test`                                                   |
| Lint    | `cargo clippy --all --benches --tests --examples --all-features` |
| Format  | `cargo fmt`                                                    |

**TypeScript/Node** (`package.json`):

| Step    | Command                                                        |
| ------- | -------------------------------------------------------------- |
| Build   | Per project (`pnpm build`, `npm run build`, etc.)              |
| Test    | Per project (`vitest`, `pnpm test`, etc.)                      |
| Lint    | `oxlint` (fallback: project lint script)                       |
| Format  | `oxfmt` (fallback: `biome format`)                             |
| Types   | `tsc --noEmit`                                                 |

**Shell** (`*.sh`):

| Step    | Command                                                        |
| ------- | -------------------------------------------------------------- |
| Lint    | `shellcheck <files>`                                           |
| Format  | `shfmt -i 2 -w <files>`                                       |

**SQL** (`*.sql`):

| Step    | Command                                                        |
| ------- | -------------------------------------------------------------- |
| Lint    | `sqlfluff lint`                                                |
| Format  | `sqlfluff format`                                              |

### 9. Self-Review

Invoke `/code-review` against the current diff to run the
review agents. Produce a list of findings ranked by severity.

### 10. Fix Findings

Address all findings from the review. For each:

- **Fix it**, or
- **Dismiss it** with reasoning (false positive, not worth
  the churn)

After addressing findings, re-run the quality pipeline
(step 8). Iterate until clean.

### 11. Commit and Push

Delete the plan file (`.claude/plans/fix-<issue-id>.md`).

Stage relevant files (prefer specific files over `git add -A`).
Do NOT stage files that may contain secrets (`.env`,
`credentials.json`, `*.pem`, `*.key`).

#### Commit message format

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):

- Format: `<type>(<scope>): <description>`
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
- Subject: lowercase after type, present tense, 50 chars max
- Blank line between subject and body
- Body: wrap at 72 chars, explain the why not the what
- Reference the issue: `Closes #N` or `Closes <beads-id>`

If the project has a commit template
(`git config --get commit.template`), follow it.

Push with tracking:

```bash
git push -u origin $(git branch --show-current)
```

If the push fails due to workflow auth errors, pull and retry:

```bash
git pull origin main --rebase && git push -u origin $(git branch --show-current)
```

### 12. Create PR/MR

#### Find template

Search for a PR/MR template in the repository using Glob:

**GitHub:** `**/*PULL_REQUEST_TEMPLATE*`

**GitLab:**
`**/.gitlab/merge_request_templates/*` or
`.gitlab/merge_request_templates/Default.md`

If not found, use the default template from
[./templates/pull-request.md](templates/pull-request.md).

#### Create draft

Write the body to a temp file to preserve formatting:

```bash
cat > /tmp/claude/pr-body.md <<'EOF'
<TEMPLATE_BODY>
EOF
```

**GitHub:**

```bash
GH_PROMPT_DISABLED=1 GIT_TERMINAL_PROMPT=0 \
  gh pr create --draft \
    --title "<TITLE>" \
    --body-file /tmp/claude/pr-body.md \
    --head "$(git branch --show-current)"
```

**GitLab:**

```bash
glab mr create --draft \
  --title "<TITLE>" \
  --description "$(cat /tmp/claude/pr-body.md)" \
  --source-branch "$(git branch --show-current)"
```

Title must be under 70 chars. Description should map changes
back to the issue requirements.

### 13. Link Back to Issue

**Forge issues:** The PR description should contain
`Closes #N`. Optionally post a summary comment on the issue
linking to the PR.

**Beads issues:** Close with a reason:

```bash
bd close <id> --reason="Fixed in PR/MR <url>"
```

### 14. Return Result

Output the PR/MR URL so the user can view it.

## Notes

- Use parallel tool calls where possible (e.g. step 2 commands)
- Requires `gh` (GitHub) or `glab` (GitLab) to be installed
  and authenticated
- If a `justfile` exists, prefer invoking build/test/lint
  through `just` targets
