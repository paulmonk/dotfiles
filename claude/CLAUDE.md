# Agent Profile

**Purpose**: Operate tasks in this repo while honouring user
preferences and house style.
**Read When**: On task initialisation and before major decisions;
re-skim when requirements shift.
**Concurrency**: Assume other agents or the user might land commits
mid-run; refresh context before summarising or editing.

## Quick Obligations

| Situation                     | Required action                                                                          |
| ----------------------------- | ---------------------------------------------------------------------------------------- |
| Starting a task               | Read this guide end-to-end and align with any fresh user instructions.                   |
| Tool or command hangs         | If a command runs longer than 5 minutes, stop it, capture logs, and check with the user. |
| Reviewing git status or diffs | Treat them as read-only context; never revert or assume missing changes were yours.      |
| Adding a dependency           | Research well-maintained options and confirm fit with the user before adding.            |

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
  one-liners. Always ask if this is the most simple intuitive
  solution.
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
- When taking on new work, follow this order:
    1. Think about the architecture.
    2. Research official docs, blogs, or papers on the best
       architecture.
    3. Review the existing codebase.
    4. Compare the research with the codebase to choose the best
       fit.
    5. Implement the fix or ask about the tradeoffs the user is
       willing to make.
- If code is very confusing or hard to understand:
    1. Try to simplify it.
    2. Add an ASCII art diagram in a code comment if it would help.
    3. Add a Mermaid diagram for documentation if it would help.

## Tool Preferences

| Purpose           | Tool              | Replaces                       |
| ----------------- | ----------------- | ------------------------------ |
| Web scraping      | **firecrawl** MCP | `curl`, `wget`, built-in fetch |
| Web search        | **exa** MCP       | Built-in web search            |
| Library docs      | **context7** MCP  | Web search for API references  |
| Repo docs         | **deepwiki** MCP  | Manual GitHub repo exploration |
| Issue management  | `bd`              | Issue and task tracking local  |
| File search       | `fd`              | `find`                         |
| Text search       | `rg` (ripgrep)    | `grep`                         |
| AST code search   | `ast-grep`        | Regex for structural patterns  |
| Semantic analysis | `semgrep`         | Manual review                  |
| Code intelligence | **serena** MCP    | Manual symbol navigation       |
| File deletion     | `trash`           | `rm` (moves to system trash)   |

## Knowledge Base

For information on a specific research topic or my workday (see daily notes)
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
- Previous conversation summaries are indexed in the **qmd**
  `memory-episodes` collection. Use this to recall past sessions.

## Development

### Comments

- **Explain the why, not the what.**
- Well-written code should be largely self-documenting.
- Comments serve a different purpose: they should explain complex
  algorithms, non-obvious business logic, or the rationale behind
  a particular implementation choice.
- Avoid comments that merely restate what the code does
  (e.g., `# increment i` above `i += 1`).
- Comments should be written as complete sentences. Block comments
  must begin with a `#` followed by a single space.

### Dependencies & External APIs

- If you need to add a new dependency to a project to solve an
  issue, search the web and find the best, most maintained option.
  Something most other folks use with the best exposed API.
- We don't want to be in a situation where we are using an
  unmaintained dependency, that no one else relies on.

### Tooling & Workflow

- **Task runner**. If a `justfile` exists, prefer `just` for
  build, test, and lint. If no `justfile` exists, look for a `Makefile`
  and use `make` if the file exists.
- **Git safety**: Do not run destructive git commands
  (`reset --hard`, `checkout .`, `clean -f`, `push --force`)
  without explicit permission.
- **Git worktrees**: Create worktrees with
  `wt switch -c <branch>` (uses `.worktrees/` at repository
  root). Use `wt list` to view, `wt merge <target>` to
  squash-merge back, `wt remove` to clean up.

### Python

| Purpose     | Tool                                        |
| ----------- | ------------------------------------------- |
| Deps & venv | `uv sync`                                   |
| Lint        | `uv run ruff check --fix`                   |
| Format      | `uv run ruff format`                        |
| Types       | `uv run ty check` (fallback: `uv run mypy`) |
| Tests       | `uv run pytest -q`                          |
| Build       | `uv_build` backend                          |

Do not introduce `pip`, Poetry, or `requirements.txt` unless
asked.

### Go

| Purpose | Tool                                                  |
| ------- | ----------------------------------------------------- |
| Build   | `go build ./...`                                      |
| Test    | `go test ./...`                                       |
| Lint    | `go vet ./...` · `staticcheck ./...` · `revive ./...` |
| Format  | `gofmt -w .`                                          |

### Rust

| Purpose | Tool                                                             |
| ------- | ---------------------------------------------------------------- |
| Build   | `cargo build`                                                    |
| Test    | `cargo test`                                                     |
| Lint    | `cargo clippy --all --benches --tests --examples --all-features` |
| Format  | `cargo fmt`                                                      |

### TypeScript / Node

| Purpose | Tool                                |
| ------- | ----------------------------------- |
| Lint    | `oxlint`                            |
| Format  | `oxfmt` (fallback: `biome format`)  |
| Types   | `tsc --noEmit`                      |
| Tests   | Per project (`vitest`, `pnpm test`) |

If npm or pnpm scripts are configured, check with the user
first.

### Terraform / Terragrunt

| Purpose  | Tool                                                |
| -------- | --------------------------------------------------- |
| Format   | `terraform fmt` · `terragrunt hclfmt`               |
| Validate | `terraform validate` · `terragrunt validate-inputs` |
| Lint     | `tflint`                                            |
| Security | `checkov` or `trivy`                                |
| Docs     | `terraform-docs`                                    |

### GitHub Actions

| Purpose  | Tool                              |
| -------- | --------------------------------- |
| Lint     | `actionlint`                      |
| Security | `zizmor`                          |

### Shell

| Purpose | Tool            |
| ------- | --------------- |
| Lint    | `shellcheck`    |
| Format  | `shfmt -i 2 -w` |

### SQL

| Purpose | Tool              |
| ------- | ----------------- |
| Lint    | `sqlfluff lint`   |
| Format  | `sqlfluff format` |

### Commit Messages

Use Conventional Commits style:

| Rule    | Convention                                              |
| ------- | ------------------------------------------------------- |
| Format  | `<type>(<scope>): <description>` with optional body     |
| Types   | `feat`, `fix`, `refactor`, `docs`, `test`, `chore`      |
| Subject | Lowercase after type, present tense, 50 chars or less   |
| Body    | Blank line after subject, wrap at 72 chars, explain why |

## Testing Philosophy

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

## Workflow

Before finishing a task:

1. Re-read your changes for unnecessary complexity, redundant code,
   and unclear naming
2. Run relevant tests — not the full suite
3. Run linters and type checker — fix everything before committing
4. Summarise changes with file and line references.
5. Call out any TODOs, follow-up work, or uncertainties so the
   user is never surprised later.
