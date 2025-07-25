# Python Code Standards
- Use keyword-only arguments (PEP 3102) for functions with multiple parameters
- Prefer functional programming patterns over OOP where appropriate
- No superflous comments about what the code does (I.e the code makes it clear what it does,
  type hints are enough etc...)
- Avoid using `hasattr` and `getattr` unless necessary. Sometimes it is just inferring the type correctly that is
  needed.
- Use the `Final` type for defining constants.
- Ordering: Constants should be defined at the top of the file, then data structures, then the rest.
- Exception handling: Make `try/except` blocks as small as possible and only catch the specific exception you need to.
- Mutations: Do not pass around state which is an arg and can be mutated (I.e dicts, lists, etc...). Use `copy/deepcopy` as needed.
- Favour immutable data structures and functional styles.
- Structure code so that it follows a narrative flow and is readable. So the public methods/classes are
  organised last, with the private functions above in the file. For classes ensure that it's magic methods (i.e. __init__), then public methods, then private methods. Only keep methods on a class if they fit with the abstraction.
- Ensure all dataclasses are `frozen=True` (where possible) and use the `kw_only=True` flag.
- Any exception to our rules should be commented with a reason why. I.e if an import has to be lazy in a function.
- Use dataclasses as data containers instead of returning dicts or tuples directly.
- Use `anyio` instead of `asyncio` for async operations.
- `@property` methods should be used to return an simple computed value, any extensive logic should be in a method.
- Keep logic together in the same file as much as possible, only separate when logic is shared between files.
- Format long numbers with _ seperators.
- Favour using Generator type functions over lists where possible, to remain performant for large data in memory.
- `utils.py` is an anti-pattern, have specific util files instead i.e `log_utils.py` etc..

# Testing

## Overview
- Use `pytest` with async support
- Use `pytest-env` for environment configuration
- Coverage reporting with minimum 90% threshold.
- Do not make external calls to the internet, `pytest-socket` blocks this for safety.
- Do not use imports within the test functions unless needed for lazy loading, default to global imports.
- No importing from conftest.py files directly. Use fixtures which are used in the test files as needed.
- Use `pytest.mark.parametrize` instead of test cases with the functions.
- Use `pytest.mark.usefixtures` only when fixture is NOT used as function parameter

## Conventions
### DAMP Principle
- Tests should be Descriptive And Meaningful Phrases
- Use descriptive test names that explain what is being tested
- Avoid test classes - use functions with descriptive names

### Test Structure
Prefer functions over classes for better readability

### Fixtures
- Leverage pytest fixtures (caplog, raises etc...) and plugins (mock, patch, etc...) for setup/teardown
- When enhancing test coverage, distribute new tests to existing files by domain
- Use `pytest-mock` for mocking instead of unittest, it exposes all the mocks and has some powerful features like spy.

### Code Organization
Each test file must map exactly to its source file:
- Source: `src/dispatch/document/parsers/mixins.py` → Test: `tests/test_document/test_parsers/test_mixins.py`
- Only difference should be the `test_` prefix
- Never create standalone enhancement or feature test files
- Consider a new test file with `__<feature>` if the file is becoming too large. For instance `test_mixins__scaling.py`
- Fixtures should always be defined at the top of the file.
