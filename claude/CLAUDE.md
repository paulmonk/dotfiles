# Global Defaults

Operate tasks while honouring user preferences and house style.
Assume other agents or the user might land commits mid-run;
refresh context before summarising or editing.

## Quick Obligations

| Situation                     | Required action                                                                          |
| ----------------------------- | ---------------------------------------------------------------------------------------- |
| Tool or command hangs         | If a command runs longer than 5 minutes, stop it, capture logs, and check with the user. |
| Reviewing git status or diffs | Treat them as read-only context; never revert or assume missing changes were yours.      |
| Adding a dependency           | Research well-maintained options and confirm fit with the user before adding.             |

## Mindset & Process

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
- **Search before pivoting**. If you are stuck or uncertain, do a
  quick web search for official docs or specs, then continue with
  the current approach. Do not change direction unless asked.

## Tool Preferences

| Purpose           | Tool              |
| ----------------- | ----------------- |
| Web scraping      | **firecrawl** MCP |
| Web search        | **exa** MCP       |
| Library docs      | **context7** MCP  |
| Repo docs         | **deepwiki** MCP  |
| Issue management  | `bd`              |
| File search       | `fd`              |
| Text search       | `rg` (ripgrep)    |
| AST code search   | `ast-grep`        |
| Semantic analysis | `semgrep`         |
| Code intelligence | **serena** MCP    |
| File deletion     | `trash`           |

## Knowledge Base

- Use **qmd** to search the Obsidian vault (research topics,
  daily notes) via the **qmd** MCP server. Notes follow the
  [PARA](https://fortelabs.com/blog/para/) system.
  - `search` for keyword matching, `vsearch` for semantic
    similarity, `query` for structured filters.
- Previous conversation summaries are in the **qmd**
  `memory-episodes` collection.

## Coding Standards

Language-specific tooling (build, test, lint, format) is in
`claude/rules/*.md` with path-filter frontmatter; those files
load automatically for matching file types.

### Comments

- **Explain the why, not the what.** Comments should cover
  non-obvious business logic, algorithm rationale, or
  implementation choices. Avoid restating what the code does.
- Complete sentences. Block comments: `#` followed by a space.

### Tooling & Workflow

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

### Commit Messages

Use Conventional Commits style:

| Rule    | Convention                                              |
| ------- | ------------------------------------------------------- |
| Format  | `<type>(<scope>): <description>` with optional body     |
| Types   | `feat`, `fix`, `refactor`, `docs`, `test`, `chore`      |
| Subject | Lowercase after type, present tense, 50 chars or less   |
| Body    | Blank line after subject, wrap at 72 chars, explain why |

## Testing Philosophy

- **Use real code over mocks.** Only mock external dependencies
  (network calls, LLM APIs, cloud services).
- **Test interface behaviour, not implementation details.** Verify
  the public API behaves correctly, not how it's implemented.
- **Test requirements:**
  - Fast and isolated where possible.
  - Descriptive test names explaining what behaviour is tested.
  - High coverage for new features, edge cases, and errors.
- Run only the tests you added or modified unless asked otherwise.

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
