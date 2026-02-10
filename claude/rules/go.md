---
paths:
  - "**/*.go"
  - "**/go.mod"
  - "**/go.sum"
---

# Go

## Tooling

- Use `gofmt -w .` to format code
- Use `go vet ./...` to lint code for best practices
- Use `staticcheck ./...` (if available) to lint code
  for best practices
- Use `go test ./...` to test code

## General Best Practices

- Use the standard library where possible. Only pull in
  dependencies when they provide significant value.
- Design zero values to be useful; users should be able
  to use a type immediately after declaration.
- **Naming:** No `Get` prefix on getters (`Owner()` not
  `GetOwner()`). Single-method interfaces use method
  name + "-er" suffix (`Reader`, `Writer`).
- **Variable names:** Length proportional to scope. Short
  names (1-3 chars) in small scopes, descriptive names
  for exported identifiers and wider scopes.
- **Receiver names:** Keep short (1-2 letters),
  abbreviate the type name, apply consistently across
  all methods of a type.
- **Initialisms:** Maintain consistent casing (`URL`,
  `HTTP`, `ID` not `Url`, `Http`, `Id`). All caps for
  initialisms regardless of position.
- **Packages:** Name for what they provide, not generic
  terms like "util" or "helper". Consider how the call
  site reads.
- **Control flow:** Avoid unnecessary `else` when `if`
  ends with `return`/`break`/`continue`. Indent error
  handling before happy path.
- **Initialisation:** Use `if err := ...; err != nil` to
  scope variables tightly. Prefer `:=` for non-zero
  values, `var` for zero-value declarations.
- **Composite literals:** Use field labels
  (`Name: value`) for resilience to struct changes.
  Omit explicit zeros when zero values suffice.
- **Shadowing:** Avoid shadowing package names or outer
  variables. Use explicit assignment (`=`) instead of
  `:=` in nested scopes when reusing variables.
- **Defer:** Use for cleanup (close files, unlock
  mutexes). Args evaluate at defer time, not call time
  (common gotcha).
- **Generics:** Use `any` instead of `interface{}`.
  Prefer generic functions over type-specific variants
  when appropriate.

## Imports

- **Grouping order:** Standard library, then project
  packages, then third-party packages. Separate groups
  with blank lines.
- **Renaming:** Rename imports only to avoid collisions.
  Use names following package naming rules.
- **Dot imports:** Never use; impairs code clarity and
  grep-ability.
- **Blank imports:** Only in main packages or tests for
  side effects; avoid in libraries.

## Context

- **First parameter:** `context.Context` is always the
  first parameter, named `ctx`.
- **Never store in structs:** Pass context through
  function parameters, not struct fields.
- **Propagate cancellation:** Pass the context you
  receive to downstream calls; don't create new
  background contexts mid-call-chain.
- **Custom types:** Never create custom context key types
  that shadow the standard library.

## Data Structures

- **Slices:** Use `slices` package for common operations
  (`slices.Contains`, `slices.Sort`). Prefer `nil`
  slices over empty initialised slices in function
  signatures. Preallocate capacity only when final size
  is known empirically.
- **Maps:** Use comma-ok idiom to distinguish missing
  keys from zero values. Use `maps` package for
  operations like `maps.Clone`.
- **Embedding:** Promoted methods receive the inner type
  as receiver, not outer (can surprise you).

## Interfaces

- **Define where consumed:** Define interfaces in the
  package that uses them, not the package that
  implements them.
- **Compile-time compliance:** Verify with
  `var _ Interface = (*Type)(nil)`.
- **Channel direction:** Specify (`chan<-`, `<-chan`) to
  convey ownership and catch mistakes at compile time.
- **Accept/Return:** Accept interfaces, return concrete
  types (unless swapping implementations is expected).

## Types and Receivers

- **Pointer receivers:** Use for methods that mutate
  state, for large structs, or when in doubt.
- **Value receivers:** Use for small immutable types,
  basic types, or when the type is naturally a value
  (like `time.Time`).
- **Consistency:** All methods on a type should use the
  same receiver type when possible.
- **Pass values:** Avoid pointer parameters for small
  types; use pointers for large structs or when mutation
  is needed.
- **Copying:** Never copy structs containing
  `sync.Mutex`, `sync.WaitGroup`, or similar
  synchronisation primitives.

## Concurrency

- **Philosophy:** Share memory by communicating, not the
  other way around.
- **Goroutine lifetime:** Make lifetimes explicit. Use
  `context.Context` for cancellation or
  `sync.WaitGroup` to track completion. Never
  fire-and-forget.
- **Channels:** Unbuffered for synchronisation, buffered
  for throughput. Use `select` with `default` for
  non-blocking ops.
- **Patterns:** Buffered channel as semaphore; worker
  pool reading from shared channel; channel of channels
  for request/response.
- **Synchronous by default:** Prefer synchronous
  functions; let callers add concurrency. Don't force
  async on consumers.
- **Documentation:** Document mutating operations'
  thread-safety. Readers assume read-only ops are safe
  unless stated otherwise.

## Error Handling

- **Explicit handling:** Handle all errors explicitly. Do
  not use `_` to ignore errors unless there is a clear
  reason documented in a comment.
- **Errors over panics:** Prefer returning errors over
  panicking. Reserve `panic` for truly unrecoverable
  situations or API misuse (like reflect).
- **Return type:** Return `error` interface, not concrete
  error types, as the final return value.
- **Custom errors:** Create custom error types
  implementing `Error() string` for rich context
  (like `os.PathError`).
- **Error strings:** Lowercase, no trailing punctuation,
  identify origin (e.g.,
  `"mypackage: failed to open"`).
- **Wrapped errors:** Use `errors.Is()` for wrapped
  errors, simple `==` for sentinel values.
- **Adding context:** Add context without duplicating
  what the underlying error provides. Use `%w` to
  preserve error chain for programmatic inspection,
  `%v` to hide implementation details. Place `%w` at
  the end of format strings.
- **Logging:** Avoid duplicate logging; return errors and
  let callers decide whether to log. Prefer `log/slog`
  for structured logging.
- **Initialisation failures:** Use `log.Fatal` for
  initialisation failures, not `panic`. Internal
  panic-recover must never escape package boundaries.

## Documentation

- **Doc comments:** Required for all exported names.
  Start with the name being documented.
- **Complete sentences:** Use proper capitalisation and
  punctuation in doc comments.
- **Concurrency safety:** Document mutating operations
  that are not thread-safe. Readers assume read-only
  operations are safe for concurrent use.
- **Cleanup requirements:** Explicitly document when and
  how to clean up resources (Close, Stop, Cancel).
- **Examples:** Include runnable examples in `_test.go`
  files for complex APIs; they appear in godoc.

## Testing

- **No assertion libraries:** Use standard `if` checks
  and `t.Error`/`t.Fatal`. Use `cmp.Diff` from
  `github.com/google/go-cmp/cmp` for complex
  comparisons.
- **Failure messages:** Include function name, inputs,
  and "got vs want" in failure messages.
- **Table-driven tests:** Group related test cases in a
  slice of structs and loop over them. Use field names
  in literals for clarity.
- **Subtests:** Use `t.Run()` for grouped cases; enables
  selective test runs and parallel execution.
- **t.Error vs t.Fatal:** Use `t.Error` with `continue`
  for per-entry failures in table tests. Reserve
  `t.Fatal` for setup failures that prevent
  continuation.
- **Helpers:** Use `t.Helper()` in setup functions to
  correctly attribute failures.
- **Goroutines in tests:** Never call
  `t.Fatal`/`t.FailNow` from goroutines other than the
  test function; use `t.Error` and return.
- **Real transports:** Test with real HTTP/RPC transports
  connected to test-double backends rather than
  hand-implementing clients.

## Cryptography

- **Random numbers:** Use `crypto/rand` for
  security-sensitive randomness, never `math/rand`.
