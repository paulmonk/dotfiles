---
paths: ["*.py", "pyproject.toml"]
---

# Python

- Use `uv` and `pyproject.toml` in all Python repos. Prefer `uv sync` for env and dependency resolution. Do not introduce `pip` venvs, Poetry, or `requirements.txt` unless asked.
- Prefer using `ty` for type checking

## General Best Practices

- **Constants:** Use immutable global constant collections (tuple, frozenset). Prefer constants over string/int literals, especially for dictionary keys, pathnames, and enums. Use `ALL_CAPS` naming.
- **Mutable globals:** Avoid mutable global state. If needed, declare at module level and treat as internal.
- **Comprehensions:** Use list, set, and dict comprehensions for simple cases. Avoid multiple `for` clauses or complex filter expressions; use loops instead.
- **Iteration:** Iterate directly over containers. Use `enumerate()` for indices, `dict.items()` for keys/values, `zip()` for parallel iteration.
- **Built-ins:** Leverage `all()`, `any()`, `reversed()`, `sum()`, `itertools.chain.from_iterable()` for flattening.
- **Generators:** Use for memory efficiency with large sequences. Document with `Yields:` section in docstrings.
- **Lambdas:** Use only for one-liners. Prefer generator expressions over `map()` or `filter()` with lambdas.
- **Decorators:** Use for cross-cutting concerns (logging, timing, caching). Use `functools.wraps()` to preserve metadata. Avoid `@staticmethod`; limit `@classmethod`.
- **Context managers:** Use `with` statements for resource management (files, locks, connections).
- **Single assignment:** Prefer single-assignment over assign-and-mutate. Use conditional expressions for simple cases.
- **Truthiness:** Use implicit false (`if not items:`) but always use explicit `if foo is None` to distinguish from other falsy values.
- **Default arguments:** NEVER use mutable default arguments. Use `None` as sentinel.
- **Properties:** Use `@property` for trivial computations. Avoid for expensive operations, side effects, or operations that can fail.
- **Modules for namespacing:** Use modules as primary namespacing mechanism, not classes. Avoid methods that don't use `self`.
- **Keyword/Positional arguments:** Use `*` for keyword-only and `/` for positional-only arguments.
- **Power features:** Avoid metaclasses, bytecode manipulation, and dynamic attribute access unless truly necessary.

## Imports

- **Style:** Use `import x` for packages and modules. Use `from x import y` only for typing, collections.abc, and specific items from large modules.
- **Grouping order:** Future imports, standard library, third-party packages, local imports. Separate groups with blank lines. Sort lexicographically within groups.
- **Full pathnames:** Always use absolute imports. Avoid relative imports except within package internals.
- **No wildcards:** Never use `from x import *`.

## Naming

- **Conventions:** `module_name`, `package_name`, `ClassName`, `ExceptionName`, `CONSTANT_NAME`, `function_name`, `method_name`, `local_var_name`, `_private_name`.
- **Mappings:** Name like `value_by_key` to enhance readability (e.g., `item = item_by_id[id]`).
- **Avoid:** Single-character names except for iterators (`i`, `j`, `k`) and context managers (`f` for files). Avoid abbreviations unfamiliar to non-native speakers.
- **Protected/Private:** Use `_single_leading_underscore` for protected, `__double_leading_underscore` only to prevent subclass collisions.

## Type Annotations

- **Coverage:** Annotate public APIs and complex internal code.
- **Abstract types:** Use `collections.abc` (`Sequence`, `Mapping`, `Iterable`) over `typing` equivalents.
- **NewType:** Use `typing.NewType` to create distinct types from primitives for domain modeling.
- **Nullable:** Explicitly mark with `X | None`. Never leave implicit.
- **Forward references:** Use `from __future__ import annotations` or string quotes for forward declarations.
- **Aliases:** Create type aliases for complex types with `CapWord` names.
- **Containers:** Use `list[T]` for homogeneous sequences, `tuple[T, ...]` for variable-length, `tuple[T1, T2]` for fixed structure.

## Docstrings

- **Format:** Use triple double-quotes. First line is summary ending with period. Blank line before detailed description.
- **Functions/Methods:** Document parameters, return values, and exceptions using Args, Returns, and Raises sections.
- **Classes:** Describe what instances represent. Document public attributes in Attributes section.
- **Modules:** Start with description of contents and usage examples.

```python
def fetch_data(url: str, timeout: int = 30) -> dict[str, Any]:
    """Fetch JSON data from a URL.

    Args:
        url: The endpoint to fetch from.
        timeout: Request timeout in seconds.

    Returns:
        Parsed JSON response as a dictionary.

    Raises:
        RequestError: If the request fails or times out.
    """
```

## Threading

- **No atomicity assumptions:** Don't rely on built-in type atomicity. Use `queue` module or `threading` locks for thread-safe communication.
- **Prefer queues:** Use `queue.Queue` for producer-consumer patterns over shared mutable state.

## Main Guard

- **Always use:** Every executable script must have `if __name__ == '__main__':` guard.
- **Minimal code:** Keep code outside the guard minimal (imports, constants, definitions only).

```python
def main() -> None:
    ...

if __name__ == '__main__':
    main()
```

## Function Design

- **Length:** Prefer functions under 40 lines. Break longer functions into smaller, focused pieces.
- **Single responsibility:** Each function should do one thing well.
- **`__repr__()` vs `__str__()`:** Implement `__repr__()` for unambiguous, developer-focused strings. `__str__()` for human-readable output.

## Libraries and Tools

- **`collections.Counter`:** For efficiently counting hashable objects.
- **`collections.defaultdict`:** For avoiding key checks when initializing dictionary values.
- **`heapq`:** Use `nlargest()`, `nsmallest()`, `merge()` for efficient operations.
- **`attrs`/`dataclasses`:** Use for classes with auto-generated boilerplate methods.
- **Serialization:** JSON for cross-language, `pydantic` for runtime validation, `cattrs` for performance with dataclasses/attrs.
- **Regular expressions:** Use `re.VERBOSE` for readable regexes. Compile regexes used multiple times. Avoid regexes for simple string checks.
- **Caching:** Use `functools.lru_cache` with care. Prefer immutable return types. Use `functools.cached_property` for methods.
- **Pickle:** Avoid due to security risks. Prefer JSON, Protocol Buffers, or msgpack.

## Testing

- **Function tests:** Use function-based pytest tests, not unittest classes.
- **Assertions:** Use pytest's native `assert` with informative expressions. Add custom messages when needed.
- **Parameterized tests:** Use `@pytest.mark.parametrize` to reduce duplication.
- **Fixtures:** Use pytest fixtures for setup, teardown, and dependency injection.
- **Mocking:** Use `mock.create_autospec()` with `spec_set=True`. Prefer injecting dependencies via fixtures over patching.
- **Temporary files:** Use pytest's `tmp_path` and `tmp_path_factory` fixtures.
- **Deterministic inputs:** Do not use random inputs in unit tests. Use deterministic, easy-to-reason-about inputs.
- **Test invariants:** Focus on invariant behaviors of public APIs, not implementation details.

## Error Handling

- **Bare except:** Never use bare `except:`. Always catch specific exceptions.
- **Scope:** Minimize try/except block scope. Only wrap the code that can raise.
- **Re-raising:** Use bare `raise` to preserve stack trace. Use `raise NewException from original` to chain. Use `raise NewException from None` to suppress context.
- **Messages:** Always include descriptive messages when raising.
- **Converting to strings:** `repr(e)` is often better than `str(e)`. Use `traceback` module for full details.
- **Returning None:** Be consistent. Use explicit `return None` if function can return values. Bare `return` only for `-> None` functions.
