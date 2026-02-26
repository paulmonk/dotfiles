# Issue Tracking with Beads

When a project has a `.beads/` directory, use `bd` for all issue
tracking. Core commands are documented in the beads plugin
context; this file covers workflow policy.

If a project does not have `.beads/` directory already then
run `beads init --stealth` to create one.

Issue types: `task`, `bug`, `feature`, `story`, `epic`, `spike`.
Priority: 0 (critical) to 4 (backlog).

## Plans Require Issues

When entering plan mode, ensure the work is tracked by a beads
issue. If you are already working on an existing issue, link
the plan to it. Otherwise, create an issue before writing the
plan.

Exceptions (no issue needed):

- Pure research or exploration with no code changes.
- The plan is a continuation of an issue already in context.

## Creating Issues

- Read the template from `~/.config/bd/templates/{type}.md`
  before creating.
- Always include `--acceptance` with checklist items.
- Apply area labels when creating issues.
- Run `bd lint <id>` after creating to verify compliance.

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below.
Work is NOT complete until `git push` succeeds.

### Mandatory Workflow

1. **File issues for remaining work** - Create issues for anything
   that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:

```bash
git pull --rebase
bd sync
git push
git status  # MUST show "up to date with origin"
```

5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

### Critical Rules

- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
