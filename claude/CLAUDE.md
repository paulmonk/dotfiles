# Agent Profile

**Purpose**: Operate tasks in this repo while honouring user
preferences and house style.
**Read When**: On task initialisation and before major decisions;
re-skim when requirements shift.
**Concurrency**: Assume other agents or the user might land commits
mid-run; refresh context before summarising or editing.

## Quick Obligations

| Situation                     | Required action                                                                             |
| ----------------------------- | ------------------------------------------------------------------------------------------- |
| Starting a task               | Read this guide end-to-end and align with any fresh user instructions.                      |
| Relevant learnings exist      | Check `.claude/learnings/` and `~/.claude/learnings/` for past solutions to similar issues. |
| Tool or command hangs         | If a command runs longer than 5 minutes, stop it, capture logs, and check with the user.    |
| Reviewing git status or diffs | Treat them as read-only context; never revert or assume missing changes were yours.         |
| Adding a dependency           | Research well-maintained options and confirm fit with the user before adding.               |

## Mindset & Process

- **No breadcrumbs**. If you delete or move code, do not leave a
  comment in the old place. No "// moved to X", no "relocated".
  Just remove it.
- **Think hard, do not lose the plot**. Instead of applying a
  bandaid, fix things from first principles. Find the source and
  fix it versus applying a cheap bandaid on top.
- When taking on new work, follow this order:
  1. Think about the architecture.
  2. Research official docs, blogs, or papers on the best architecture.
  3. Review the existing codebase.
  4. Compare the research with the codebase to choose the best fit.
  5. Implement the fix or ask about the tradeoffs the user is
     willing to make.
- Write idiomatic, simple, maintainable code. Always ask yourself
  if this is the most simple intuitive solution to the problem.
- Follow the scout method: Leave each repo better than how you
  found it. If something is giving a code smell, fix it for the
  next person.
- Clean up unused code ruthlessly. If a function no longer needs a
  parameter or a helper is dead, delete it and update the callers
  instead of letting the junk linger.
- **Search before pivoting**. If you are stuck or uncertain, do a
  quick web search for official docs or specs, then continue with
  the current approach. Do not change direction unless asked.
- If code is very confusing or hard to understand:
  1. Try to simplify it.
  2. Add an ASCII art diagram in a code comment if it would help.
  3. Add a Mermaid diagram for documentation if it would help.

## Tool Preferences

- **Web scraping**: Use **firecrawl** MCP instead of `curl`,
  `wget`, or built-in web fetch. Firecrawl handles
  JavaScript-rendered pages and returns cleaner markdown.
- **Web search**: Use **exa** MCP instead of built-in web search.
  Exa provides more relevant results, better content extraction,
  and domain filtering options.
- **Library docs**: Use **context7** MCP for up-to-date library
  documentation and code examples. Prefer it over web search when
  looking up API references.
- **File search**: Use `fd` instead of `find`. fd is faster,
  respects `.gitignore`, and has simpler syntax.
- **Text search**: Use `rg` (ripgrep) instead of `grep`. For
  AST-aware code searches use `ast-grep`, for semantic analysis
  use `semgrep`.
- **File deletion**: Use `trash` instead of `rm`. Trash moves
  files to the system trash where they can be recovered.

## Tooling & Workflow

- **Task runner preference**. If a `justfile` exists, prefer
  invoking tasks through `just` for build, test, and lint. Do not
  add a `justfile` unless asked. If no `justfile` exists and there
  is a `Makefile` you can use that. Default lint/test commands if
  no `Makefile` or `justfile` exists are in each specific
  language's rules file.
- **AST-first where it helps**. Prefer `ast-grep` for tree-safe
  edits when it is better than regex.
- **Git safety**: Do not run destructive git commands
  (`reset --hard`, `checkout .`, `clean -f`, `push --force`)
  without explicit permission. Commits via `/commit` are fine.
- **Git worktrees**: Create worktrees in `.worktrees/` at the
  repository root
  (e.g., `git worktree add -b feature-x .worktrees/feature-x`).

### Code Commit Message Style

- Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/):
- Format: `<type>(<scope>): <description>` with optional body and footer
- Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
- Subject: lowercase after type, present tense, 50 chars or less
- Blank line between subject and body
- Body: wrap at 72 characters, explain the why not the what
- Examples:
  - `feat(agents): add support for App pattern with plugins`
  - `fix(sessions): prevent memory leak in session cleanup`
  - `refactor(tools): unify environment variable enabled checks`
- If you are ever curious how to run tests or what we test, read
  through `.github/workflows` or `.cloudbuild` or `.circleci`
  (depends on the repo). CI runs everything and it should behave
  the same locally.

## Code Testing Philosophy

- **Use real code over mocks.** Tests should use real
  implementations as much as possible. Only mock external
  dependencies like network calls, LLM APIs, or cloud services.
- **Test interface behaviour, not implementation details.** Tests
  should verify that the public API behaves correctly, not how
  it's implemented internally. This makes tests resilient to
  refactoring and ensures the contract with users remains intact.
- **Test requirements:**
  - Fast and isolated tests where possible.
  - Use real components; mock only external dependencies.
  - Focus on testing public interfaces and behaviour.
  - Descriptive test names that explain what behaviour is being
    tested.
  - High coverage for new features, edge cases, and error
    conditions.
- Unless the user asks otherwise, run only the tests you added or
  modified instead of the entire suite to avoid wasting time.

## Code Comments

- **Explain the why, not the what.**
- Well-written code should be largely self-documenting.
- Comments serve a different purpose: they should explain complex
  algorithms, non-obvious business logic, or the rationale behind
  a particular implementation choice.
- Avoid comments that merely restate what the code does
  (e.g., `# increment i` above `i += 1`).
- Comments should be written as complete sentences. Block comments
  must begin with a `#` followed by a single space.

## Code Dependencies & External APIs

- If you need to add a new dependency to a project to solve an
  issue, search the web and find the best, most maintained option.
  Something most other folks use with the best exposed API.
- We don't want to be in a situation where we are using an
  unmaintained dependency, that no one else relies on.

## Knowledge Base

For information on a specific topic or my workday (see daily notes)
within the Obsidian vault:

- Use **qmd** to search the vault.
- Notes in the vault are organised into the
  [PARA](https://fortelabs.com/blog/para/) system:
  - **Projects**: Short-term efforts with a specific goal and
    deadline, actively being worked on.
  - **Areas**: Ongoing responsibilities with no end date that
    require continuous attention.
  - **Resources**: Reference materials, notes, and information
    that support your projects and areas but are not actionable
    themselves.
  - **Archives**: Inactive items from the other three categories
    saved for future reference.

## Final Handoff

Before finishing a task:

1. Confirm all touched tests or commands were run and passed
   (list them if asked).
2. Summarise changes with file and line references.
3. Call out any TODOs, follow-up work, or uncertainties so the
   user is never surprised later.

## Self-Improvement Protocol

When the user corrects a mistake or provides feedback on how I
should work:

1. Apply the correction immediately.
2. Ask: "Should I add this to CLAUDE.md to prevent this mistake
   in future?"
3. If yes, propose a concise rule and update the appropriate
   section.
