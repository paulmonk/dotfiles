---
paths: **/*.rs, **/Cargo.{toml,lock}
---

# Rust

## Tooling

| Purpose | Tool                                                             |
| ------- | ---------------------------------------------------------------- |
| Build   | `cargo build`                                                    |
| Test    | `cargo test`                                                     |
| Lint    | `cargo clippy --all --benches --tests --examples --all-features` |
| Format  | `cargo fmt`                                                      |

## General Best Practices

- Do NOT use unwraps or anything that can panic in Rust code,
  handle errors. Obviously in tests unwraps and panics are fine!
- Prefer `crate::` over `super::` for imports in non-test code.
  One-level `super::` in test modules is acceptable. If you see
  deep `super::super::` chains, refactor to use `crate::`.
- Avoid `pub use` on imports unless you are re-exposing a
  dependency so downstream consumers do not have to depend on it
  directly.
- Skip global state via `lazy_static!`, `Once`, or similar;
  prefer passing explicit context structs for any shared state.
- Prefer strong types over strings, use enums and newtypes when
  the domain is closed or needs validation.
- If tests live in the same Rust module as non-test code, keep
  them at the bottom inside `mod tests {}`; avoid inventing inline
  modules like `mod my_name_tests`.

## Cargo.toml Lints

When creating new Rust projects, include these clippy lints:

```toml
[lints.clippy]
pedantic = { level = "warn", priority = -1 }
# Panic prevention
unwrap_used = "deny"
expect_used = "warn"
panic = "deny"
panic_in_result_fn = "deny"
unimplemented = "deny"
# No cheating
allow_attributes = "deny"
# Code hygiene
dbg_macro = "deny"
todo = "deny"
print_stdout = "deny"
print_stderr = "deny"
# Safety
await_holding_lock = "deny"
large_futures = "deny"
exit = "deny"
mem_forget = "deny"
# Pedantic relaxations (too noisy)
module_name_repetitions = "allow"
similar_names = "allow"
```
