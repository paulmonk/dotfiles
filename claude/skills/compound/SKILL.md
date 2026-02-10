---
name: compound
description: Document solved problems to compound knowledge across sessions
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git add:*), Bash(git status:*), Bash(git diff:*), Bash(mkdir:*)
---

# Compound

Capture and document solutions to non-trivial problems so
knowledge compounds over time. Triggers on confirmation
phrases or manual invocation after solving a problem.

## Trigger Phrases

Auto-invoke when the user says:

- "that worked", "it's fixed", "working now", "problem solved", "that did it"

Skip trivial fixes (typos, obvious syntax errors, simple config changes).

## Usage

```text
/compound
```

## Workflow

### 1. Gather Context

Extract from the conversation (ask if missing):

| Required       | Description                                 |
| -------------- | ------------------------------------------- |
| **Symptom**    | Exact error message or observable behaviour |
| **Module**     | File, package, or system affected           |
| **Root cause** | Why it happened (not just what was wrong)   |
| **Solution**   | What fixed it, with code if applicable      |
| **Prevention** | How to avoid this in future                 |

**BLOCKING:** Do not proceed without symptom and root cause.

### 2. Check Existing Documentation

Search for similar issues in both project and global scope:

```bash
grep -r "<symptom-keywords>" .claude/learnings/ ~/.claude/learnings/ docs/ 2>/dev/null || true
```

If similar documentation exists, present options:

1. **Create new doc with cross-reference** (recommended if
   different root cause)
2. **Update existing doc** (if same issue, new context)
3. **Skip** (already well documented)

### 3. Determine Destination

**Scope decision:** Is this learning specific to this project, or universal?

| Scope       | Destination    | Location                                        |
| ----------- | -------------- | ----------------------------------------------- |
| **Project** | Learning file  | `<project>/.claude/learnings/<date>-<topic>.md` |
| **Project** | CLAUDE.md rule | `<project>/CLAUDE.md`                           |
| **Project** | Code comment   | Inline in source                                |
| **Project** | Project docs   | `README.md` or `docs/`                          |
| **Global**  | CLAUDE.md rule | `~/.claude/CLAUDE.md` (applies to all projects) |
| **Global**  | Learning file  | `~/.claude/learnings/<date>-<topic>.md`         |

**Guidelines:**

- Language gotchas (e.g., Go nil maps) → Global CLAUDE.md rule
- Tool/library quirks you'll hit again → Global learning file
- Project-specific patterns → Project .claude/learnings/
- Architecture decisions → Project docs

### 4. Create Documentation

**For learning files**, use this structure:

`````markdown
# <Descriptive Title>

**Date:** YYYY-MM-DD
**Module:** <affected module/file>
**Severity:** critical | high | medium | low

## Symptom

<Exact error message or behaviour>

## Root Cause

<Technical explanation of why this happened>

## Solution

<What fixed it, with code examples>

```<language>
// Before (broken)
...

// After (fixed)
...
```

## Prevention

<How to avoid this in future>

## Related

- <links to related issues or docs>
`````

**For CLAUDE.md rules**, keep concise:

````markdown
- **<Action to take or avoid>.** <Brief explanation of why.>
````

### 5. Cross-Reference

If related documentation exists:

1. Add "Related" links to the new doc
2. Update existing docs with back-links

### 6. Decision Menu

After documentation, present options:

1. **Continue** - Return to original task
2. **Add to CLAUDE.md** - Promote key insight to a rule
3. **Link related issues** - Connect to similar problems
4. **View documentation** - Display what was captured

## Quality Checklist

Good documentation includes:

- [ ] Exact error messages (copy-pasted, not paraphrased)
- [ ] Specific file:line references where applicable
- [ ] Technical explanation (why, not just what)
- [ ] Code examples showing before/after
- [ ] Prevention guidance

Avoid:

- Vague descriptions ("it didn't work")
- Missing technical details
- Code dumps without explanation
- No prevention guidance

## Examples

**Global learning file** (`~/.claude/learnings/2026-02-01-go-nil-map.md`):

`````markdown
# Go nil map panic on assignment

**Date:** 2026-02-01
**Module:** internal/cache/store.go
**Severity:** medium

## Symptom

panic: assignment to entry in nil map

## Root Cause

Declared map with `var m map[string]int` but never initialised it.
In Go, the zero value of a map is nil, and you cannot assign to a nil map.

## Solution

Initialise the map before use:

```go
// Before
var m map[string]int
m["key"] = 1  // panic

// After
m := make(map[string]int)
m["key"] = 1  // works
```

## Prevention

Always initialise maps with `make()` or a literal `{}`.
Consider using struct fields with initialisation in constructor.
`````

**CLAUDE.md rule**:

````markdown
- **Initialise Go maps before use.** The zero value is nil; assignment to nil maps panics.
````

## Notes

- Only document non-trivial solutions (multiple investigation attempts)
- Prefer patterns over one-off fixes
- **Scope rule:** If you'll hit this again in other
  projects, it's global (`~/.claude/`). If it's specific
  to this codebase, it's project-level (`.claude/` in
  project root).
- Create the learnings directory if it doesn't exist:
  `mkdir -p .claude/learnings` or
  `mkdir -p ~/.claude/learnings`
