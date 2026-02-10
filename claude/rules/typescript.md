---
paths:
  - "**/*.{ts,tsx,js,jsx}"
  - "**/package.json"
  - "**/tsconfig.json"
---

# TypeScript

## Tooling

- If npm or pnpm scripts are configured, ask the user
  to confirm first. Otherwise:
  - Use `tsc --noEmit` to type check code
  - Use `eslint` to lint code for best practices
  - Use `biome format` to format code. If unavailable,
    use `prettier` instead.

## General Best Practices

- **Modern browsers:** Assume modern browser support
  unless otherwise specified. Skip polyfills for
  ES2020+ features.
- **Immutability:** Favour `readonly`, `as const`, and
  immutable patterns. Avoid mutation where practical.
- **Pure functions:** Prefer functions without side
  effects. Isolate side effects at boundaries.
- **Composition over inheritance:** Favour small
  composable functions and interfaces over class
  hierarchies.
- **Simplicity:** Avoid clever abstractions. Repetition
  is often cheaper than the wrong abstraction.
- **Explicit over implicit:** Be explicit about types at
  boundaries, nullability, and error conditions.

## Imports & Exports

- **Named exports only:** Avoid default exports to
  prevent ambiguity and improve refactoring.
- **Import style:** Use named imports for
  frequently-used symbols. Use namespace imports
  (`import * as foo`) for large APIs.
- **Type imports:** Use `import type` and `export type`
  for type-only references.
- **Relative paths:** Prefer relative imports within
  projects. Limit parent traversal depth
  (`../../../` is a smell).
- **No namespaces:** Use ES6 modules exclusively.
  TypeScript `namespace` is disallowed.
- **Export visibility:** Only export symbols used outside
  the module.
- **No mutable exports:** Use getter functions if
  external code needs dynamic values.

## Naming

- **UpperCamelCase:** Classes, interfaces, types, enums,
  decorators, type parameters.
- **lowerCamelCase:** Variables, parameters, functions,
  methods, properties, module aliases.
- **CONSTANT_CASE:** Global constants, enum values.
- **No decoration:** Don't encode type info in names. No
  `IMyInterface`, no Hungarian notation, no trailing
  underscores.
- **Acronyms as words:** `loadHttpUrl` not
  `loadHTTPURL`. Treat acronyms as single words.
- **Descriptive names:** Avoid abbreviations unfamiliar
  to external readers. Short names OK for variables in
  scope under 10 lines.

## Variables

- **const by default:** Use `const` unless reassignment
  is required, then use `let`.
- **Never var:** `var` is disallowed.
- **One per declaration:** Declare one variable per
  statement.

## Arrays

- **Literal syntax:** Use `[]` not `Array()` constructor.
- **Simple types:** Use `T[]` or `readonly T[]` for
  simple element types.
- **Complex types:** Use `Array<T>` when element type is
  complex.
- **No sparse arrays:** Don't set non-numeric properties
  on arrays.
- **Spread for iterables:** Use spread syntax for copying
  or concatenating arrays.

## Objects

- **Literal syntax:** Use `{}` not `Object()` constructor.
- **No for-in:** Use `Object.keys()`,
  `Object.values()`, `Object.entries()`, or `for...of`
  instead.
- **Destructuring:** Keep parameter destructuring simple
  (single level, unquoted properties).
- **Prefer Map/Set:** Use `Map` and `Set` over
  object-based dictionaries when keys are dynamic.

## Classes

- **Visibility:** Minimise exposure. Omit `public`
  modifier (it's the default). Use `private` or
  `protected` explicitly.
- **readonly:** Mark properties never reassigned outside
  constructor.
- **Parameter properties:** Use constructor parameter
  properties to reduce boilerplate.
- **Field initializers:** Initialise members at
  declaration when possible.
- **No private fields:** Use TypeScript `private`
  modifier, not `#ident` syntax.
- **Getters must be pure:** No side effects in getters.
  Don't define pass-through accessors.
- **No prototype manipulation:** Only framework code may
  touch prototypes.

## Functions

- **Function declarations:** Prefer `function foo()`
  over `const foo = () =>` for named functions.
- **Arrow functions:** Use in method bodies for `this`
  access, callbacks, and inline functions.
- **Concise arrow bodies:** Use for expressions that
  return values. Use block bodies for side effects.
- **Rest parameters:** Use instead of `arguments` object.
- **No this rebinding:** Don't use `.bind()`, `.call()`,
  `.apply()` to rebind `this`. Use arrow functions.

## Control Flow

- **Always brace:** Use braced blocks even for single
  statements.
- **for-of over for-in:** Prefer `for...of` for
  iteration. If using `for...in`, check
  `hasOwnProperty`.
- **Strict equality:** Always use `===` and `!==`.
  Exception: `== null` to match both `null` and
  `undefined`.
- **Switch default:** All switch statements require a
  `default` case (place last).
- **No fall-through:** Each case must terminate. Empty
  cases may fall through.

## Error Handling

- **Throw Error objects:** Always `throw new Error()`,
  never throw primitives.
- **Catch as Error:** Assume caught values are `Error`
  type. Add comments for non-Error throws.
- **Empty catch:** Only with explanatory comment.

## Type System

- **Inference:** Rely on inference for trivially inferred
  types (literals, `new` expressions).
- **Explicit generics:** Specify type parameters when
  initialising empty collections.
- **Interfaces over type aliases:** Prefer `interface`
  for object types. Use `type` for unions,
  intersections, mapped types.
- **Optional fields:** Use `?` syntax, not
  `| undefined`.
- **No null in aliases:** Never include `| null` or
  `| undefined` in type alias definitions. Add at
  usage.
- **unknown over any:** Use `unknown` for truly unknown
  types. Narrow with type guards before use.
- **Tuple types:** Prefer tuples over Pair-style
  interfaces. Consider inline object literals for 2-3
  properties.

## Type Assertions

- **Avoid assertions:** Prefer runtime checks or proper
  typing.
- **as syntax:** When necessary, use `as` (not angle
  brackets).
- **Double assertions:** Use `as unknown as Type` when
  required.
- **Object literals:** Use type annotations (`:`) not
  assertions (`as`).
- **Non-null assertions:** Avoid `!`. Prefer explicit
  null checks.

## Strings

- **Template literals:** Use for interpolation,
  multi-line strings, or complex concatenation. Not for
  simple static strings.
- **No line continuations:** Don't use backslash at line
  end.

## Type Coercion

- **String():** Use `String(x)` or template literals,
  not `'' + x`.
- **Boolean():** Use explicit comparison for enums.
  Implicit coercion OK for other types in conditionals.
- **Number():** Use `Number(x)` with `isFinite()` check.
  Avoid `parseInt`/`parseFloat` unless parsing
  non-base-10.

## Comments

- **JSDoc for documentation:** Use `/** */` for
  user-facing documentation.
- **Line comments for implementation:** Use `//` for
  implementation notes.
- **No block comments:** Use multiple `//` lines,
  not `/* */`.
- **Markdown in JSDoc:** Write JSDoc content in Markdown.

## Disallowed

- **Wrapper objects:** Never use `String`, `Boolean`,
  `Number`, `Object` constructors.
- **const enum:** Use plain `enum` instead.
- **debugger:** Not in production code.
- **with:** Never use.
- **eval:** No dynamic code evaluation.
- **@ts-ignore:** Use proper typing instead.
  `@ts-expect-error` only in tests with explanation.
- **Modifying builtins:** Never extend or modify
  built-in prototypes.
