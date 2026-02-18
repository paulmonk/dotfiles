---
name: gh-merge-dependabot
description: Evaluate and merge dependabot PRs with parallel builds, dependency analysis, and sequential merging
allowed-tools: Bash, Read, Write, Glob, Grep, Task
argument-hint: "<org/repo> [--skip-config-audit]"
---

# Merge Dependabot PRs

Evaluate and merge open dependabot PRs for a repository.
Runs parallel build/test evaluations per PR, merges passing
ones sequentially, and reports on anything that needs human
attention.

## Arguments

- `$REPO`: GitHub org/repo (e.g. `trailofbits/algo`)
- `$OPTIONS`: Optional. `--skip-config-audit` skips Phase 0.

## Workflow

Execute every phase sequentially. Do not stop or ask for
confirmation at any phase.

### Phase 0: Dependabot Config Audit

Skip if `$OPTIONS` includes `--skip-config-audit`.

Detect package ecosystems by checking for indicator files:

| Indicator                                  | Ecosystem        |
| ------------------------------------------ | ---------------- |
| `pyproject.toml` + `uv.lock`               | `uv`             |
| `pyproject.toml` (no `uv.lock`)            | `pip`            |
| `Cargo.toml`                               | `cargo`          |
| `package.json`                             | `npm`            |
| `go.mod`                                   | `gomod`          |
| `Gemfile`                                  | `bundler`        |
| `Dockerfile`, `docker-compose.yml`         | `docker`         |
| `.github/workflows/*.yml`                  | `github-actions` |

Read `.github/dependabot.yml` and verify:

1. **Coverage**: every detected ecosystem has an `updates` entry
2. **uv vs pip**: repos with `uv.lock` must use `uv`, not `pip`
3. **Schedule**: every entry has `schedule.interval: "weekly"`
4. **Cooldown**: every entry has `cooldown.default-days: 7`
5. **Grouped updates**: every entry has a `groups` key

If the file is missing or any condition fails, create a
corrective PR on branch `fix/dependabot-config` with the
fixes. Use this template per ecosystem entry:

```yaml
- package-ecosystem: "{ecosystem}"
  directory: "/"
  schedule:
    interval: "weekly"
  cooldown:
    default-days: 7
  groups:
    {ecosystem}-dependencies:
      patterns:
        - "*"
```

Preserve existing extra fields (labels, reviewers, etc.).
This PR is non-blocking; continue to Phase 1.

### Phase 1: Discovery and Baseline

#### 1a. Fetch dependabot PRs

```bash
gh pr list --repo $REPO --author "app/dependabot" \
  --state open \
  --json number,title,headRefName,labels,files,mergeable
```

If zero PRs, print "No open dependabot PRs for $REPO" and
stop.

#### 1b. Categorise PRs

- **Actions dep**: all changed files under `.github/`
- **Library dep**: everything else

#### 1c. Baseline build and test

Check out the default branch. Discover the build/test
commands:

1. Check `justfile` or `Makefile` for targets
2. Read `.github/workflows/` for build steps
3. Fall back to language defaults:

| Manifest         | Build                        | Test                   |
| ---------------- | ---------------------------- | ---------------------- |
| `Cargo.toml`     | `cargo build`                | `cargo test`           |
| `pyproject.toml` | `uv pip install -e ".[dev]"` | `pytest -q`            |
| `package.json`   | `pnpm install && pnpm build` | `pnpm test`            |
| `go.mod`         | `go build ./...`             | `go test ./...`        |
| `Gemfile`        | `bundle install`             | `bundle exec rspec`    |

Run build and tests. If main is broken, stop and report.

Record the baseline dependency tree from lockfiles
(`uv pip freeze`, `cargo tree`, `npm ls --all`,
`go list -m all`, etc.).

### Phase 2: Dependency Graph Analysis

#### 2a. Build transitive dependency map

Parse lockfiles to understand the full dependency tree.

#### 2b. Group overlapping PRs

Two PRs overlap if their packages have a transitive
dependency relationship. Group them into batches. Actions
PRs are always independent.

#### 2c. Sort and queue

Topological order: leaf dependencies first, core/shared
last. Process in waves of 5 if more than 5 work units.

Print the grouping plan before proceeding.

### Phase 3: Parallel Evaluation

Fetch each PR branch:

```bash
git fetch origin pull/{number}/head:pr-{number}
```

Launch up to 5 parallel evaluation agents. Send all
evaluation requests in a single batch.

#### Library dep subagent instructions

Each subagent receives the repo path, PR numbers, baseline
dep tree, and build/test commands. Steps:

1. **Checkout**: `git checkout pr-{number}` (or create a
   merge branch for batches)
2. **Transitive analysis**: generate dep tree, diff against
   baseline. Flag downgrades, major bumps, new/removed
   transitive deps.
3. **Build**: run build command, report if it fails
4. **Test**: run test command. Pre-existing failures on main
   do not count against the PR.
5. **Verdict**:
   - **PASS**: build and tests pass, no flags
   - **WARN**: passes but has concerns (new deps, major
     bumps)
   - **FAIL**: build fails, new test failures, or merge
     conflicts

#### Actions dep subagent instructions

1. **Checkout** the PR branch
2. **Diff analysis**: identify bumped actions and version
   change magnitude. For major bumps, search for breaking
   changes using web search.
3. **Pin verification**: check `uses:` lines are SHA-pinned
   with version comments. Tag-only refs are a WARN.
4. **Verdict**: same PASS/WARN/FAIL scheme

### Phase 4: Sequential Merge

Process work units in dependency order.

For each **PASS** verdict:

1. Approve:

   ```bash
   gh pr review --repo $REPO --approve {number} \
     --body "Automated: build, tests, and dep analysis passed."
   ```

2. Merge:

   ```bash
   gh pr merge --repo $REPO --squash --admin {number}
   ```

3. Verify merged state:

   ```bash
   gh pr view --repo $REPO {number} --json state
   ```

4. Update main locally:

   ```bash
   git checkout main && git pull origin main
   ```

5. **Re-test next PR** before merging. Rebase onto updated
   main and re-run build/tests. If it fails after prior
   merges, mark as **SKIPPED**.

**WARN**: do not merge, include in report for human review.
**FAIL**: do not merge, include error context.

### Phase 5: Cleanup and Report

Delete local PR branches. Print summary:

```markdown
## Dependabot PR Summary for $REPO

| PR | Title | Type | Verdict | Action | Notes |
|----|-------|------|---------|--------|-------|

**Merged:** {count}
**Needs human review (WARN):** {count}
**Failed:** {count}
**Skipped (post-merge conflict):** {count}
```

If a config PR was created in Phase 0, include its number.

Print full evaluation reports for non-merged PRs.
