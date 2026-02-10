---
name: code-review
description: Comprehensive code review using specialised agents
allowed-tools: Read,Glob,Grep,Task,TaskCreate,TaskList,TaskUpdate,Bash(git diff:*),Bash(git blame:*),Bash(git log:*),Bash(git status:*),Bash(gh issue view:*),Bash(gh search:*),Bash(gh issue list:*),Bash(gh pr comment:*),Bash(gh pr diff:*),Bash(gh pr view:*),Bash(gh pr list:*)
argument-hint: "[review-aspects] or [PR number/URL]"
disable-model-invocation: true
---

# Code Review

Run a comprehensive code review using multiple specialised
agents, each focusing on a different aspect of code quality.

## Usage

```text
/code-review [aspects]           # Review local changes (git diff)
/code-review [PR-number-or-URL]  # Review a specific PR
/code-review tests errors        # Review specific aspects only
```

## Workflow

### 1. Determine Review Scope

- If argument is a number or URL: fetch the PR with `gh pr view`
- Otherwise: use `git diff` to identify changed files
- Parse arguments for specific review aspects

### 2. Available Review Aspects

| Aspect     | Agent Focus                              | When Applicable         |
| ---------- | ---------------------------------------- | ----------------------- |
| `code`     | CLAUDE.md compliance, bugs, code quality | Always                  |
| `tests`    | Test coverage quality and completeness   | Test files changed      |
| `errors`   | Silent failures, error handling          | Error handling code     |
| `comments` | Documentation accuracy                   | Comments added/modified |
| `types`    | Type design and invariants               | New types introduced    |
| `simplify` | Clarity and maintainability              | After passing review    |
| `all`      | Run all applicable reviews               | Default                 |

### 3. Launch Review Agents

For each applicable aspect, launch a specialised agent
from `.claude/agents/` using the Task tool:

**Sequential approach** (default): Easier to understand,
each report completes before next
**Parallel approach** (add `parallel` argument): Faster
for comprehensive review

**Orchestration guidance:**

- **Sequential** when agents build on each other's output:
  code-reviewer, code-simplifier, comment-analyzer
  (each refines the previous)
- **Parallel** when agents analyse independently:
  type-design-analyzer + silent-failure-hunter
  (no shared context needed)
- After fixes, re-run code-reviewer to verify resolution
  before closing review

Example Task invocation:

```text
Task tool with:
  subagent_type: "code-reviewer"  # Agent name from .claude/agents/
  prompt: "Review the changes in: <list of files or git diff output>"
  model: as specified below
```

### 4. Agents (defined in `.claude/agents/`)

| Agent                        | Aspect     | When to Run             |
| ---------------------------- | ---------- | ----------------------- |
| `code-reviewer`              | `code`     | Always                  |
| `code-test-analyzer`         | `tests`    | Test files changed      |
| `code-silent-failure-hunter` | `errors`   | Error handling code     |
| `code-comment-analyzer`      | `comments` | Comments added/modified |
| `code-type-design-analyzer`  | `types`    | New types introduced    |
| `code-simplifier`            | `simplify` | After passing review    |

Each agent has detailed instructions in its file. Key outputs:

- **code-reviewer**: Confidence scores 0-100, only reports >= 80
- **code-test-analyzer**: Criticality ratings 1-10 (10 = essential)
- **code-silent-failure-hunter**: Severity levels CRITICAL/HIGH/MEDIUM
- **code-comment-analyzer**: Identifies comment rot and
  misleading elements
- **code-type-design-analyzer**: Rates 4 dimensions 1-10 each
- **code-simplifier**: Preserves functionality while improving clarity

### 5. Aggregate Results

After agents complete, summarise findings by severity:

```markdown
# Code Review Summary

## Critical Issues (X found)

- [agent]: Issue description [file:line]

## Important Issues (X found)

- [agent]: Issue description [file:line]

## Suggestions (X found)

- [agent]: Suggestion [file:line]

## Strengths

- What's well-done in this code

## Recommended Actions

1. Fix critical issues first
2. Address important issues
3. Consider suggestions
4. Re-run review after fixes
```

## Confidence Scoring

Agents filter their output by confidence to minimise false positives:

| Score  | Meaning                                      |
| ------ | -------------------------------------------- |
| 0-25   | Likely false positive or pre-existing issue  |
| 26-50  | Minor nitpick not explicitly in CLAUDE.md    |
| 51-75  | Valid but low-impact issue                   |
| 76-90  | Important issue requiring attention          |
| 91-100 | Critical bug or explicit CLAUDE.md violation |

**Only report issues with confidence >= 80**

## False Positives to Ignore

- Pre-existing issues (not introduced in this change)
- Issues a linter/typechecker/compiler would catch
- Pedantic nitpicks a senior engineer wouldn't call out
- General code quality issues unless explicitly required in CLAUDE.md
- Issues silenced in code (lint ignore comments)
- Intentional functionality changes related to the broader change
- Issues on lines not modified in this change

## Examples

**Full review of local changes:**

```text
/code-review
```

**Review specific PR:**

```text
/code-review 123
/code-review https://github.com/org/repo/pull/123
```

**Specific aspects only:**

```text
/code-review tests errors    # Test coverage and error handling only
/code-review comments        # Documentation accuracy only
/code-review simplify        # Code simplification only
```

**Parallel execution:**

```text
/code-review all parallel    # Launch all agents in parallel
```

## Output Format

For PR reviews, post a comment back to the user
(NOT on the pull request itself) using this format:

```markdown
### Code Review

Found X issues:

1. **[CRITICAL]** Brief description (CLAUDE.md says "...")
   [file:line link with full SHA]

2. **[IMPORTANT]** Brief description
   [file:line link with full SHA]

---

Or if no issues:

### Code Review

No issues found.
```

## Notes

- Use `gh` for GitHub interactions, not web fetch
- Create a todo list before starting
- Cite and link each issue (include CLAUDE.md reference
  if applicable)
- Links must use full SHA:
  `https://github.com/org/repo/blob/abc123.../file.ts#L13-L17`
- Run early (before creating PR) rather than after
- Focus on changes, not entire codebase
- Re-run after fixes to verify resolution
