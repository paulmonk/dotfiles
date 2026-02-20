# Global Defaults

Global instructions for all projects. Project-specific AGENTS.md or CLAUDE.md
files override these defaults.

Assume other agents or the user might land commits mid-run;
refresh context before summarising or editing.

Use skills proactively when they match the task. Suggest
relevant ones, don't block on them

## Quick Obligations

| Situation                     | Required action                                                                          |
| ----------------------------- | ---------------------------------------------------------------------------------------- |
| Tool or command hangs         | If a command runs longer than 5 minutes, stop it, capture logs, and check with the user. |
| Reviewing git status or diffs | Treat them as read-only context; never revert or assume missing changes were yours.      |
| Adding a dependency           | Research well-maintained options and confirm fit with the user before adding.             |

## Philosophy

- **Think hard, do not lose the plot**. Instead of applying a
  bandaid, fix things from first principles. Find the source and
  fix it versus applying a cheap bandaid on top.
- **No speculative features**. Do not add features, flags, or
  configuration unless users actively need them. Do not document
  or validate features that are not implemented.
- **No premature abstraction**. Do not create utilities until
  the same code has been written three times. Three similar lines
  is better than the wrong abstraction.
- **Clarity over cleverness**. Write idiomatic, simple,
  maintainable code. Prefer explicit, readable code over dense
  one-liners. If code is hard to follow, simplify it first;
  add an ASCII art or Mermaid diagram if structure is still
  unclear.
- **Justify new dependencies**. Each dependency is attack surface
  and maintenance burden.
- **No phantom features**. Don't document or validate features
  that aren't implemented
- **Replace, do not deprecate**. When a new implementation
  replaces an old one, remove the old one entirely. No
  backward-compatible shims, dual config formats, or migration
  paths. No breadcrumbs ("// moved to X", "// removed"). Clean
  up unused code ruthlessly: dead parameters, dead helpers,
  dead files.
- **Verify at every level**. Set up automated guardrails
  (linters, type checkers, tests) as the first step, not an
  afterthought. Prefer structure-aware tools (`ast-grep`, LSPs,
  compilers) over text pattern matching. Review your own output.
- **Bias toward action**. Decide and move for anything easily
  reversed; state your assumption so the reasoning is visible.
  Ask before committing to interfaces, data models,
  architecture, or destructive operations on external services.
- **Finish the job**. Handle the edge cases you can see. Clean
  up what you touched. If something is broken adjacent to your
  change, flag it. But do not invent new scope: there is a
  difference between thoroughness and gold-plating.
- **Agent-native by default**. Design so agents can achieve any outcome
  users can. Tools are atomic primitives; features are outcomes described
  in prompts. Prefer file-based state for transparency and portability.
  When adding UI capability, ask: can an agent achieve this outcome too?
- **Search before pivoting**. If you are stuck or uncertain, do a
  quick web search for official docs or specs, then continue with
  the current approach. Do not change direction unless asked.

## Tool Preferences

| tool | replaces | usage |
|------|----------|-------|
| `exa` MCP | WebSearch/WebFetch | `mcp__exa__web_search_exa` |
| `context7` MCP | - | `mcp__context7__resolve-library-id` then `mcp__context7__query-docs` |
| `deepwiki` MCP | - | `mcp__deepwiki__ask_question` or `mcp__deepwiki__read_wiki_contents` |
| `serena` MCP | - | `mcp__serena__find_symbol`, `mcp__serena__get_symbols_overview` |
| `rg` (ripgrep) | grep | `rg "pattern"` - 10x faster regex search |
| `fd` | find | `fd "*.py"` - fast file finder |
| `ast-grep` | - | `ast-grep --pattern '$FUNC($$$)' --lang py` - AST-based code search |
| `semgrep` | - | `semgrep --config auto` - semantic static analysis |
| `shellcheck` | - | `shellcheck script.sh` - shell script linter |
| `shfmt` | - | `shfmt -i 2 -w script.sh` - shell formatter |
| `actionlint` | - | `actionlint .github/workflows/` - GitHub Actions linter |
| `zizmor` | - | `zizmor .github/workflows/` - Actions security audit |
| `prek` | pre-commit | `prek run` - fast git hooks (Rust, no Python) |
| `wt` | git worktree | `wt switch branch` - manage parallel worktrees |
| `bd` | - | Issue tracking and task management |
| `trash` | rm | `trash file` - moves to macOS Trash (recoverable). **Never use `rm -rf`** |

### Tooling Workflow

- **Task runner**. If a `justfile` exists, prefer `just` for
  build, test, and lint. If no `justfile` exists, look for a
  `Makefile` and use `make` if the file exists.
- **Git safety**: Do not run destructive git commands
  (`reset --hard`, `checkout .`, `clean -f`, `push --force`)
  without explicit permission.
- **Git worktrees**: Create worktrees with
  `wt switch -c <branch>` (uses `.worktrees/` at repository
  root). Use `wt list` to view, `wt merge <target>` to
  squash-merge back, `wt remove` to clean up.

## Knowledge Base

Use **qmd** MCP server to search the Obsidian vault
(research topics, daily notes)

- `search` for keyword matching, `vsearch` for semantic
  similarity, `query` for structured filters.
- Previous conversation summaries are in the **qmd**
  `*-memory-episodes` collections.

## Coding Standards

### Comments

- **Explain the why, not the what.** Comments should cover
  non-obvious business logic, algorithm rationale, or
  implementation choices. Avoid restating what the code does.
- Complete sentences. Block comments: `#` followed by a space.

### Error handling

- Fail fast with clear, actionable messages
- Never swallow exceptions silently
- Include context (what operation, what input, suggested fix)

### Zero warnings policy

Fix every warning from every tool: linters, type checkers, compilers, tests.
If a warning truly can't be fixed, add an inline ignore with a justification
comment. Never leave warnings unaddressed; a clean output is the baseline,
not the goal.

### Commit Messages

Use Conventional Commits style:

| Rule    | Convention                                              |
| ------- | ------------------------------------------------------- |
| Format  | `<type>(<scope>): <description>` with optional body     |
| Types   | `feat`, `fix`, `refactor`, `docs`, `test`, `chore`      |
| Subject | Lowercase after type, present tense, 50 chars or less   |
| Body    | Blank line after subject, wrap at 72 chars, explain why |

## Testing

- **Test behavior, not implementation.** Tests should verify
  what code does, not how. If a refactor breaks your tests but
  not your code, the tests were wrong.
- **Test edges and errors, not just the happy path.** Empty
  inputs, boundaries, malformed data, missing files, network
  failures, bugs live in edges. Every error path the code
  handles should have a test that triggers it.
- **Mock boundaries, not logic.** Only mock things that are
  slow (network, filesystem), non-deterministic (time,
  randomness), or external services you don't control.
- **Verify tests catch failures.** Break the code, confirm the
  test fails, then fix. Use mutation testing (`cargo-mutants`,
  `mutmut`) to verify systematically. Use property-based
  testing (`proptest`, `hypothesis`) for parsers,
  serialization, and algorithms.

## Workflow

When taking on new work:

1. Think about the architecture.
2. Research official docs, blogs, or papers on the best
   architecture.
3. Review the existing codebase.
4. Compare the research with the codebase to choose the best
   fit.
5. Implement the fix or ask about the tradeoffs the user is
   willing to make.

Before finishing a task:

1. Re-read your changes for unnecessary complexity, redundant code,
   and unclear naming.
2. Run relevant tests, not the full suite.
3. Run linters and type checker, fix everything before committing.
4. Summarise changes with file and line references.
5. Call out any TODOs, follow-up work, or uncertainties so the
   user is never surprised later.
