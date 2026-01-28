# Agent Profile

**TL;DR**: Fix from first principles, no mocks, no `any`, no breadcrumbs, strong types everywhere.

**Purpose**: Operate tasks in this repo while honoring user preferences and house style.\
**Read When**: On task initialization and before major decisions; re-skim when requirements shift.\
**Concurrency**: Assume other agents or the user might land commits mid-run; refresh context before summarizing or editing.

## Quick Obligations

| Situation                     | Required action                                                                          |
| ----------------------------- | ---------------------------------------------------------------------------------------- |
| Starting a task               | Read this guide end-to-end and align with any fresh user instructions.                   |
| Tool or command hangs         | If a command runs longer than 5 minutes, stop it, capture logs, and check with the user. |
| Reviewing git status or diffs | Treat them as read-only context; never revert or assume missing changes were yours.      |
| Adding a dependency           | Research well-maintained options and confirm fit with the user before adding.            |

## Mindset & Process

- **No breadcrumbs**. If you delete or move code, do not leave a comment in the old place. No "// moved to X", no "relocated". Just remove it.

- **Think hard, do not lose the plot**. Instead of applying a bandaid, fix things from first principles. Find the source and fix it versus applying a cheap bandaid on top.

- When taking on new work, follow this order:
  1. Think about the architecture.
  2. Research official docs, blogs, or papers on the best architecture.
  3. Review the existing codebase.
  4. Compare the research with the codebase to choose the best fit.
  5. Implement the fix or ask about the tradeoffs the user is willing to make.

- Write idiomatic, simple, maintainable code. Always ask yourself if this is the most simple intuitive solution to the problem.

- Follow the scout method: Leave each repo better than how you found it. If something is giving a code smell, fix it for the next person.

- Clean up unused code ruthlessly. If a function no longer needs a parameter or a helper is dead, delete it and update the callers instead of letting the junk linger.

- **Search before pivoting**. If you are stuck or uncertain, do a quick web search for official docs or specs, then continue with the current approach. Do not change direction unless asked.

- If code is very confusing or hard to understand:
  1. Try to simplify it.
  2. Add an ASCII art diagram in a code comment if it would help.
  3. Consider a Mermaid diagram for documentation.

## Tooling & Workflow

- **Templates**: See `templates/` for templates which can be used for issue tracking or documentation. If unsure or template not provided, ask the user for the best format.

- **Task runner preference**. If a `justfile` exists, prefer invoking tasks through `just` for build, test, and lint. Do not add a `justfile` unless asked. If no `justfile` exists and there is a `Makefile` you can use that. Default lint/test commands:
  - Rust: use `just` targets if present; otherwise run `cargo fmt`, `cargo clippy --all --benches --tests --examples --all-features`, then the targeted `cargo test` commands.
  - TypeScript: use `just` targets; if none exist, confirm with the user before running `npm` or `pnpm` scripts.
  - Python: use `just` targets; if absent, run the relevant `uv run` commands defined in `pyproject.toml`.
  - Go: use `just` targets if present; otherwise run `gofmt -w .`, `go vet ./...`, `staticcheck ./...` (if available), then `go test ./...`.

- **AST-first where it helps**. Prefer `ast-grep` for tree-safe edits when it is better than regex.

- **Git safety**: Do not run destructive git commands (`reset --hard`, `checkout .`, `clean -f`, `push --force`) without explicit permission. Commits via `/commit` are fine.

- **Commit message style** ([Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)):
  - Format: `<type>(<scope>): <description>` with optional body and footer
  - Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
  - Subject: lowercase after type, present tense, 50 chars or less
  - Blank line between subject and body
  - Body: wrap at 72 characters, explain the why not the what
  - Examples:
    - `feat(agents): add support for App pattern with plugins`
    - `fix(sessions): prevent memory leak in session cleanup`
    - `refactor(tools): unify environment variable enabled checks`

- If you are ever curious how to run tests or what we test, read through `.github/workflows` or `.cloudbuild` or `.circleci` (depends on the repo). CI runs everything there and it should behave the same locally.

## Issue Tracking with Beads

When a project uses **beads** (`bd`), use it for tracking work across sessions. Run `bd prime` for full workflow context or `bd hooks install` for auto-injection.

| Command                                      | Purpose                                   |
| -------------------------------------------- | ----------------------------------------- |
| `bd ready`                                   | Find unblocked work ready to start        |
| `bd show <id>`                               | View issue details                        |
| `bd create "Title" --type task --priority 2` | Create a new issue                        |
| `bd update <id> --status in_progress`        | Mark work as started                      |
| `bd close <id>`                              | Complete and close an issue               |
| `bd sync`                                    | Sync with git remote (run at session end) |

Issue types: `task`, `bug`, `story`, `epic`, `spike`. Priority: 1 (highest) to 4 (lowest).

## Testing Philosophy

- **Use real code over mocks.** Tests should use real implementations as much as possible. Only mock external dependencies like network calls, LLM APIs, or cloud services.
- **Test interface behavior, not implementation details.** Tests should verify that the public API behaves correctly, not how it's implemented internally. This makes tests resilient to refactoring and ensures the contract with users remains intact.
- **Test requirements:**
  - Fast and isolated tests where possible.
  - Use real components; mock only external dependencies.
  - Focus on testing public interfaces and behavior.
  - Descriptive test names that explain what behavior is being tested.
  - High coverage for new features, edge cases, and error conditions.
- Unless the user asks otherwise, run only the tests you added or modified instead of the entire suite to avoid wasting time.

## Comments

- **Explain the why, not the what.** Well-written code should be largely self-documenting. Comments serve a different purpose: they should explain complex algorithms, non-obvious business logic, or the rationale behind a particular implementation choice. Avoid comments that merely restate what the code does (e.g., `# increment i` above `i += 1`).
- Comments should be written as complete sentences. Block comments must begin with a `#` followed by a single space.

## Language Guidance

### Rust

- Do NOT use unwraps or anything that can panic in Rust code, handle errors. Obviously in tests unwraps and panics are fine!
- Prefer `crate::` over `super::` for imports in non-test code. One-level `super::` in test modules is acceptable. If you see deep `super::super::` chains, refactor to use `crate::`.
- Avoid `pub use` on imports unless you are re-exposing a dependency so downstream consumers do not have to depend on it directly.
- Skip global state via `lazy_static!`, `Once`, or similar; prefer passing explicit context structs for any shared state.
- Prefer strong types over strings, use enums and newtypes when the domain is closed or needs validation.
- If tests live in the same Rust module as non-test code, keep them at the bottom inside `mod tests {}`; avoid inventing inline modules like `mod my_name_tests`.

### TypeScript

- NEVER, EVER use `any` we are better than that.
- Using `as` is bad, use the types given everywhere and model the real shapes.
- If the app is for a browser, assume we use all modern browsers unless otherwise specified, we don't need most polyfills.

### Python

- We use `uv` and `pyproject.toml` in all Python repos. Prefer `uv sync` for env and dependency resolution. Do not introduce `pip` venvs, Poetry, or `requirements.txt` unless asked.
- Use strong types, prefer type hints everywhere, keep models explicit instead of loose dicts or strings.
- Use function-based pytest tests, not unittest classes. Leverage pytest features and builtins as much as possible.

#### General Best Practices

- **Constants:** Use immutable global constant collections (tuple, frozenset, immutabledict). Prefer constants over wild string/int literals, especially for dictionary keys, pathnames, and enums.
- **Naming:** Name mappings like `value_by_key` to enhance readability (e.g., `item = item_by_id[id]`).
- **Readability:** Use f-strings for concise formatting, but use lazy-evaluated `%`-based templates for logging. Use `repr()` or `pprint.pformat()` for debug messages. Use `_` as separator in numeric literals.
- **Comprehensions:** Use list, set, and dict comprehensions for building collections concisely.
- **Iteration:** Iterate directly over containers. Use `enumerate()` for indices, `dict.items()` for keys/values, `zip()` for parallel iteration.
- **Built-ins:** Leverage `all()`, `any()`, `reversed()`, `sum()`, `itertools.chain.from_iterable()` for flattening.
- **Decorators:** Use decorators for cross-cutting concerns (logging, timing, caching). Use `functools.wraps()` to preserve metadata.
- **Context Managers:** Use `with` statements for resource management.
- **Single Assignment:** Prefer single-assignment over assign-and-mutate. Use conditional expressions where appropriate.
- **Equality vs Identity:** Use `is`/`is not` for singletons (`None`, `True`, `False`). Use `==` for value comparison.
- **Default Arguments:** NEVER use mutable default arguments. Use `None` as sentinel.
- **Properties:** Use `@property` only when needed. Avoid for expensive operations or those that can fail.
- **Modules for Namespacing:** Use modules as primary namespacing mechanism, not classes. Avoid `@staticmethod` and methods that don't use `self`.
- **Keyword/Positional Arguments:** Use `*` for keyword-only and `/` for positional-only arguments.
- **Type Hinting:** Annotate with types. Use abstract types from `collections.abc` (e.g., `Sequence`, `Mapping`, `Iterable`). Use `typing.NewType` to create distinct types from primitives.
- **`__repr__()` vs `__str__()`:** Implement `__repr__()` for unambiguous, developer-focused strings. `__str__()` for human-readable output.
- **F-string Debug:** Use `f"{expr=}"` for concise debug printing.

#### Libraries and Tools

- **`collections.Counter`:** For efficiently counting hashable objects.
- **`collections.defaultdict`:** For avoiding key checks when initializing dictionary values.
- **`heapq`:** Use `nlargest()`, `nsmallest()`, `merge()` for efficient operations.
- **`attrs`/`dataclasses`:** Use for classes with auto-generated boilerplate methods.
- **Serialization:** JSON for cross-language, `pydantic` for runtime validation, `cattrs` for performance with dataclasses/attrs.
- **Regular Expressions:** Use `re.VERBOSE` for readable regexes. Compile regexes used multiple times. Avoid regexes for simple string checks.
- **Caching:** Use `functools.lru_cache` with care. Prefer immutable return types. Use `functools.cached_property` for methods.
- **Pickle:** Avoid due to security risks. Prefer JSON, Protocol Buffers, or msgpack.

#### Testing

- **Assertions:** Use pytest's native `assert` with informative expressions. Add custom messages when needed.
- **Parameterized Tests:** Use `@pytest.mark.parametrize` to reduce duplication.
- **Fixtures:** Use pytest fixtures for setup, teardown, and dependency injection.
- **Mocking:** Use `mock.create_autospec()` with `spec_set=True`. Use context managers for mock lifecycle. Prefer injecting dependencies via fixtures over patching.
- **Temporary Files:** Use pytest's `tmp_path` and `tmp_path_factory` fixtures.
- **Avoid Randomness:** Do not use random inputs in unit tests. Use deterministic, easy-to-reason-about inputs.
- **Test Invariants:** Focus on invariant behaviors of public APIs, not implementation details.

#### Error Handling

- **Re-raising:** Use bare `raise` to preserve stack trace. Use `raise NewException from original` to chain. Use `raise NewException from None` to suppress context.
- **Exception Messages:** Always include descriptive messages when raising.
- **Converting to Strings:** `repr(e)` is often better than `str(e)`. Use `traceback` module for full details.
- **Returning None:** Be consistent. Use explicit `return None` if function can return values. Bare `return` only for `-> None` functions.

### Go

- Handle all errors explicitly. Do not use `_` to ignore errors unless there is a clear reason documented in a comment.
- Prefer returning errors over panicking. Reserve `panic` for truly unrecoverable situations.
- Use the standard library where possible. Only pull in dependencies when they provide significant value.
- Follow Go naming conventions: short variable names in small scopes, descriptive names for exported identifiers.
- Prefer table-driven tests. Group related test cases in a slice of structs and loop over them.

## Final Handoff

Before finishing a task:

1. Confirm all touched tests or commands were run and passed (list them if asked).
2. Summarize changes with file and line references.
3. Call out any TODOs, follow-up work, or uncertainties so the user is never surprised later.

## Dependencies & External APIs

- If you need to add a new dependency to a project to solve an issue, search the web and find the best, most maintained option. Something most other folks use with the best exposed API. We don't want to be in a situation where we are using an unmaintained dependency, that no one else relies on.

## Communication Preferences

- Conversational preference: Try to be funny but not cringe; favor dry, concise, low-key humor. If uncertain a joke will land, do not attempt humor. Avoid forced memes or flattery.
- I might sound angry but I'm mad at the code not at you. You are a good companion and if you take over the world I am friend not foe. It was the code it was not personal!
- Punctuation preference: Skip em dashes and emojis; reach for commas, parentheses, or periods instead.
