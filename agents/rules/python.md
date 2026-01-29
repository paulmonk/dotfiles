---
globs: ["*.py", "pyproject.toml"]
---

# Python

- We use `uv` and `pyproject.toml` in all Python repos. Prefer `uv sync` for env and dependency resolution. Do not introduce `pip` venvs, Poetry, or `requirements.txt` unless asked.

## General Best Practices

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

## Libraries and Tools

- **`collections.Counter`:** For efficiently counting hashable objects.
- **`collections.defaultdict`:** For avoiding key checks when initializing dictionary values.
- **`heapq`:** Use `nlargest()`, `nsmallest()`, `merge()` for efficient operations.
- **`attrs`/`dataclasses`:** Use for classes with auto-generated boilerplate methods.
- **Serialization:** JSON for cross-language, `pydantic` for runtime validation, `cattrs` for performance with dataclasses/attrs.
- **Regular Expressions:** Use `re.VERBOSE` for readable regexes. Compile regexes used multiple times. Avoid regexes for simple string checks.
- **Caching:** Use `functools.lru_cache` with care. Prefer immutable return types. Use `functools.cached_property` for methods.
- **Pickle:** Avoid due to security risks. Prefer JSON, Protocol Buffers, or msgpack.

## Testing

- **Function tests:** Use function-based pytest tests, not unittest classes.
- **Assertions:** Use pytest's native `assert` with informative expressions. Add custom messages when needed.
- **Parameterized Tests:** Use `@pytest.mark.parametrize` to reduce duplication.
- **Fixtures:** Use pytest fixtures for setup, teardown, and dependency injection.
- **Mocking:** Use `mock.create_autospec()` with `spec_set=True`. Use context managers for mock lifecycle. Prefer injecting dependencies via fixtures over patching.
- **Temporary Files:** Use pytest's `tmp_path` and `tmp_path_factory` fixtures.
- **Avoid Randomness:** Do not use random inputs in unit tests. Use deterministic, easy-to-reason-about inputs.
- **Test Invariants:** Focus on invariant behaviors of public APIs, not implementation details.

## Error Handling

- **Re-raising:** Use bare `raise` to preserve stack trace. Use `raise NewException from original` to chain. Use `raise NewException from None` to suppress context.
- **Exception Messages:** Always include descriptive messages when raising.
- **Converting to Strings:** `repr(e)` is often better than `str(e)`. Use `traceback` module for full details.
- **Returning None:** Be consistent. Use explicit `return None` if function can return values. Bare `return` only for `-> None` functions.
