# Shell

## Tooling

- Use `shellcheck` to lint code for best practices
- Use `shfmt -i 2` to format code

## General Best Practices

- **Small utilities only:** Limit shell to small utilities,
  wrapper scripts, and glue code under 100 lines.
- **Consider alternatives:** If performance matters, control flow
  is complex, or the script exceeds 100 lines, use Python, Go, or
  another language.
- **No SUID/SGID:** Never use SUID or SGID on shell scripts. Use
  `sudo` for elevated access.

## Script Setup

- **Shebang:** Always start with `#!/bin/bash` or
  `#!/usr/bin/env bash`.
- **Strict mode:** Enable
  `set -o errexit -o errtrace -o pipefail -o nounset`.
- **Header comment:** Every file needs a comment describing its
  purpose.
- **File order:** Shebang, header comment, `set` options,
  constants, includes/sources, functions, main logic.
- **Extensions:** Executables may omit `.sh`; libraries must use
  `.sh` and be non-executable.

## Variables & Naming

- **Brace syntax:** Prefer `"${var}"` over `"$var"` for clarity.
- **Arrays for lists:** Use arrays for storing lists and
  command-line arguments.
- **Functions:** Lowercase with underscores. Use `::` prefix for
  namespacing (e.g., `mylib::init`).
- **Variables:** Lowercase with underscores for local variables.
- **Constants:** UPPERCASE with underscores, declared at file top
  with `readonly` or `declare -r`.

## Control Flow

- **Double brackets:** Use `[[ ... ]]` over `[ ... ]` or `test`.
- **Arithmetic:** Use `(( ... ))` for numeric comparisons.
- **No piping to while:** Use process substitution or `readarray`
  instead.

```bash
# Bad: variables set in while are lost
cat file | while read -r line; do ...

# Good: use process substitution
while read -r line; do
  process "${line}"
done < <(cat file)
```

## Functions

- **main function:** Scripts with multiple functions should define
  a `main()` function called at the end.
- **Local variables:** Always declare variables with `local` inside functions.

```bash
main() {
  local input="$1"
  validate "${input}"
  process "${input}"
}

main "$@"
```

## Error Handling

- **Errors to STDERR:** Error messages must go to STDERR using
  `>&2`.
- **Check return values:** Verify command success using `if` or `$?`.
- **PIPESTATUS:** For pipelines, check `PIPESTATUS` array
  immediately after execution.
- **Exit traps:** Use `trap` for cleanup on exit or error.

```bash
log() { echo "[$(basename "$0")] $*" >&2; }

cleanup() {
  rm -f "${tmpfile:-}"
}
trap cleanup EXIT
```

## Disallowed

- **eval:** Never use. Creates security vulnerabilities.
- **Backticks:** Use `$(...)` instead.
- **Aliases in scripts:** Use functions instead.
- **let and expr:** Use `$(( ... ))` or `(( ... ))` for
  arithmetic.

## Patterns

- **Self-documenting help:** Use `#/` comments for help text
  extracted with `grep`.

```bash
#!/bin/bash
#/ Usage: script.sh [options]
#/   -h, --help    Show this help

usage() { grep '^#/' "$0" | cut -c4-; exit 0; }
[[ "${1:-}" =~ ^(-h|--help)$ ]] && usage
```
