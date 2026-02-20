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
and known solutions. Use the MCP tools configured
(exa for web search and page content, context7 for library docs).

Skip this step when the fix is clear from the codebase alone.

### 5. Plan

Save a plan covering:

- Summary of the issue requirements
- Every file to create or modify
- Approach and key design decisions
- Risks or open questions
- Relevant code paths by file:line

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
wt switch -c <prefix>/issue-<id>
```

### 7. Implement

Implement the plan across all necessary files. Follow the
project's coding standards and language rules. Keep changes
minimal and focused on the issue requirements.

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
3. **Read CLAUDE.md or AGENTS.md** for project-specific
   quality gates.

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

Invoke `/code-review` against the current diff. Produce a
list of findings ranked by severity.

### 10. Fix Findings

Address all findings from the review. For each:

- **Fix it**, or
- **Dismiss it** with reasoning (false positive, not worth
  the churn)

After addressing findings, re-run the quality pipeline
(step 8). Iterate until clean.

### 11. Commit, Push, and Open PR

Invoke `/commit-push-pr <issue-id>` to commit the changes,
push the branch, and create a draft PR/MR. The issue ID
ensures the commit message and PR body reference the issue
correctly.

## Notes

- Use parallel tool calls where possible (e.g. step 2 commands)
- Requires `gh` (GitHub) or `glab` (GitLab) to be installed
  and authenticated
- If a `justfile` exists, prefer invoking build/test/lint
  through `just` targets
