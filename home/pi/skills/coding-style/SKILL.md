---
name: coding-style
description: "Enforce functional programming style on any code I write or review. Use whenever writing, editing, or reviewing code. Triggers on [implement, write code, edit code, refactor, review, PR review] and any code-related task."
license: MIT
metadata:
  author: binh
  version: "2.0"
---

# Coding Style — Universal Functional Programming

Whenever you write or review code — in *any* language — apply functional programming principles as far as the language permits. This is not a per-language guide. These are **universal principles**. Every language has some way to express them. Find that way.

The goal is **deterministic, composable, side-effect-free code** where data flows through pure transformations.

---

## How to Use This Skill

1. **Learn the universal principles below** — they apply to any language, including ones this skill never mentions.
2. **When encountering a language**, ask: *"What FP primitives does this language have?"* (immutable data, higher-order functions, pattern matching, expression-oriented constructs, monadic types, etc.)
3. **Map each principle** to that language's closest construct — don't force idioms from other languages.
4. **When in doubt**, search the language's stdlib or ecosystem for functional libraries.

---

## Universal Principles (Apply to Every Language)

### 1. Immutability First

> Bind once. Never reassign. Use immutable/read-only data structures.

| What to do | How to find it in any language |
|---|---|
| Prefer `const`/`final`/`let`/`val` (single-assignment) over mutable variables | Look for `const`, `final`, `readonly`, `val`, `let`. If only `var`/`let` (mutable), discipline yourself to assign once. |
| Use persistent/immutable collections | Hash array mapped tries, persistent vectors, copy-on-write. Keywords: "immutable", "persistent", "frozen". |
| Copy-and-update instead of mutate-in-place | Spread (`...`), `with` syntax, record update, setter returning new copy. |
| Prefer building new values over modifying existing ones | `builder` pattern, `copy()` method, `derive` macros, `clone`-then-modify. |

**Flags**: `var` (unless language only has var), `.push()`/`.append()` (mutating), `x = x + 1`, setter methods that mutate `this`/`self`.

### 2. Expression-Oriented

> Everything returns a value. Prefer expressions (which evaluate to a value) over statements (which don't).

| What to do | How to find it in any language |
|---|---|
| Use `if`/`match`/`when`/`case` that returns a value | Ternary `?:`, `match`/`switch` as expression, `if` as expression, `case`/`when` |
| Chain operations: `x.f().g().h()` | Method chaining, pipe operator `|>`, function composition `.`, `>>=` |
| Avoid blocks that only produce side effects | `if (x) { doThing(); }` → prefer `val result = if (x) doThing() else default` |
| IIFE (immediately invoked function expression) when needed | `(function(){...})()`, `do { ... }`, `(() => { ... })()` |

**Flags**: `if` without `else` (missing branch), `switch` as statement (fall-through), `return` statements in the middle of functions (early returns), bare `for` loops that don't produce a collection.

### 3. Pure Functions

> Same input → same output. No side effects. Isolate I/O to the edges.

| What to do | How to find it in any language |
|---|---|
| Functions that take params and return values — nothing else | No global reads/writes, no stdout, no file access, no network, no DB |
| Avoid mutation of arguments | Copy inputs before modifying (or don't modify them at all) |
| Avoid random/date/time/global-state-dependent logic | Pass those as parameters |
| Use dependency injection explicitly | Pass config/context as argument, not global variable |

**Flags**: `print`/`console.log`/`println`/`echo`/`printf` inside business logic, reading globals, writing to files, modifying arguments, `void` return type (signals side effect), random/time inside pure computation.

### 4. No Raw Loops

> Replace `for`/`while` with higher-order operations that express *what* not *how*.

| What to do | How to find it in any language |
|---|---|
| `map` — transform each element | `.map()`, `.select()`, list comprehensions, `for ... yield`, `Transform` |
| `filter` — keep matching elements | `.filter()`, `.where()`, `.grep()`, `.Select()`, `if` inside comprehension |
| `reduce`/`fold` — collapse to one value | `.reduce()`, `.fold()`, `.inject()`, `.aggregate()`, `sum()` |
| `flat_map` — map then flatten | `.flat_map()`, `.bind()`, `.SelectMany()`, nested comprehensions |
| `any`/`all`/`none` — predicates | `.any()`, `.some()`, `.all()`, `.every()`, `.none()` |
| `take`/`drop`/`slice` — subsequences | `.take()`, `.skip()`, `.limit()`, `.offset()`, slicing |
| `group_by`/`partition` — split | `.group_by()`, `.partition()`, `.chunk()`, `.split()` |
| `zip` — combine pairwise | `.zip()`, `.zip_with()`, `.transpose()` |

**Flags**: `for`, `while`, `loop`, `forEach` (if it's just a loop in disguise with no return value), manual index counters (`i++`), `C-style for`.

### 5. Compose, Don't Mutate

> Data flows through transformations. Each step produces a new value.

```text
input → parse → validate → transform → output
```

Not:

```text
var x = input
modify x step 1
modify x step 2   # (was x modified elsewhere? who knows)
return x
```

| What to do | How to find it in any language |
|---|---|
| Pipe / flow / thread operators | `|>`, `&>`, `.>>`, function composition, method chaining |
| Data flows left-to-right or top-to-bottom | Readable pipeline, not nested inside-out |
| No intermediate mutable variables | Each step is a named binding or a chain link |

**Flags**: Modifying a variable in multiple places, unclear ownership of data, "step 1: ... step 2: ..." comments on reassignments, deeply nested function calls `f(g(h(x)))`.

### 6. Type-Driven Design

> Use the type system to make illegal states unrepresentable.

| What to do | How to find it in any language |
|---|---|
| Sum types / discriminated unions over nullable/boolean flags | `enum`, `union`, `sealed class`, `variant`, `Either`, `Option` |
| Never use `null`/`nil`/`undefined` — use `Option`/`Maybe`/`Optional` | Language's optional type, or a library |
| Never use exceptions for control flow — use `Result`/`Either` | Language's error-as-value type, or a library |
| Newtypes / branded types for domain primitives | `type Email = ...`, wrappers, opaque types |
| Parse, don't validate | Construct validated types at the boundary, not ad-hoc checks throughout |

**Flags**: `null`, `nil`, `undefined`, `None` (except as explicit option), `throw` in business logic, `try`/`catch` for control flow, `if x != null`, boolean overloaded parameters `(isAdmin=true)`.

### 7. Explicit Over Implicit

> No magic. No global state. No monkey-patching. No reflection for business logic.

| What to do | How to find it in any language |
|---|---|
| Pass dependencies as arguments | Config, DB connections, services as parameters |
| Return errors as values, not throw | `Result<T,E>` or tuple `(T, err)` |
| Name everything — no magic numbers/strings | Named constants, enums, config files |
| Module-level scope = `private`/`local` by default | Export only what's needed |

**Flags**: Global variables, singleton pattern, DI container as magic, runtime type inspection for dispatch, stringly-typed APIs.

---

## How to Apply This in Any Language

When you encounter a language you haven't used before:

### Step 1: Identify the FP primitives

Check for:
- **Immutable bindings**: `const`/`val`/`let`/`final`/`readonly`/`immutable`
- **Immutable data structures**: Look for `List`, `Map`, `Set` with `immutable`/`persistent`/`frozen` qualifiers, or clone-on-write conventions
- **Expression forms**: Does `if`/`match`/`switch` return a value? Is there a ternary `?:`?
- **Higher-order functions**: `map`, `filter`, `reduce`, `flatMap`, `any`, `all` — on arrays, iterables, streams, sequences
- **Function composition**: `|>` pipe, `.` composition, method chaining
- **Monadic types**: `Option`/`Maybe`, `Result`/`Either`, `Try` — either built-in or via library
- **Pattern matching**: `match`, `case`, `switch` expressions, destructuring
- **Algebraic data types**: `enum`, `union`, `sealed class`, `variant`, `tagged union`
- **Lambdas/closures**: Anonymous functions, function references, blocks

### Step 2: Search for idiomatic FP libraries

```
<language> functional programming library
<language> immutable collections
<language> option either result type
<language> pipe operator
```

### Step 3: Map each universal principle

| Universal Principle | Universal Finding Strategy |
|---|---|
| Immutability | `const` / `val` / `readonly` / `final` / `immutable` |
| Expression-oriented | Does `if` return a value? What about `switch`/`match`? Ternary? |
| Pure functions | Can I avoid `void` return? Can I pass dependencies as args? |
| No raw loops | Does the stdlib have `.map()` / `.filter()` / `.reduce()` on collections? |
| Compose | Pipe operator `|>`? Method chaining? Function composition? |
| Type-driven | Sum types? `Option`/`Result`? Pattern matching? |
| Explicit | Are there globals? Can I inject dependencies as function parameters? |

### Step 4: Write a small reference

After learning the primitives, write down:

```markdown
## <Language> FP Quick Reference

| Principle | How to do it |
|---|---|
| Immutable binding | `const x = ...` (always) |
| Map | `collection.map(f)` |
| Filter | `collection.filter(pred)` |
| Reduce | `collection.reduce(f, init)` |
| Option type | `Optional<T>` / `Option<T>` |
| Result type | `Result<T, E>` / `Either<L, R>` |
| Pattern matching | `match expr { ... }` |
| Pipe | `|>` operator / `.chain()` |
| Immutable data | `@Frozen` / `ImmutableList.of(...)` |
```

Store this reference in the project or add it to a `.fp-style.md` for the team.

---

## Concrete Demonstrations

Below are demonstrations of the universal principles in specific languages. These are not exhaustive — they show the *shape* of FP in each language so you can recognize the same patterns elsewhere.

### Nix
```nix
# Immutable, expression-oriented, pure (Nix is already functional)
lib.pipe inputs [
  (map (name: inputs.${name}.packages.${system}))
  lib.flatten
  (filter (x: x ? meta.description))
]
```

### Rust
```rust
// Pure function with iterator chain, no mutation
fn process(items: &[Item]) -> Vec<Output> {
    items.iter()
        .filter(|i| i.is_valid())
        .map(|i| i.compute())
        .collect()
}
// Sum types make illegal states unrepresentable
enum HttpResult { Success(Data), NotFound, ServerError(String) }
```

### TypeScript / JavaScript
```typescript
// Expression-oriented pipeline, no mutation
const processed = data
  .filter((x): x is Valid => x.status === "ok")
  .map((x) => ({ ...x, computed: derive(x.value) }))
  .toSorted((a, b) => a.priority - b.priority);

// Sum type over nullable
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };
```

### Python
```python
# Comprehensions instead of loops, dataclass frozen
@dataclass(frozen=True)
class Point:
    x: float
    y: float

cleaned = [
    item.derive() for item in data
    if item.status == "valid"
]
```

### Go
```go
// Generic helpers wrap imperative loops in a functional API
func Filter[T any](xs []T, pred func(T) bool) []T {
    result := make([]T, 0, len(xs))
    for _, x := range xs {
        if pred(x) { result = append(result, x) }
    }
    return result
}
func Map[T, U any](xs []T, f func(T) U) []U {
    result := make([]U, len(xs))
    for i, x := range xs { result[i] = f(x) }
    return result
}
// Immutable copy-on-write
func (c Config) WithPort(p int) Config { c.Port = p; return c }
```

### Shell (Bash)
```bash
# Pipe transformations, no while-read loops
filtered=$(jq -r '.[] | select(.active) | .name' < input.json | sort -u)
local -r count=$(echo "$data" | grep -c "pattern")
```

### Java
```java
// Streams, immutable records, Optional/Result
record User(String name, boolean active) {}

List<String> names = users.stream()
    .filter(User::active)
    .map(User::name)
    .toList(); // immutable list

// Optional instead of null
Optional<User> findByName(String name) { ... }
```

### C#
```csharp
// LINQ for declarative data processing, records for immutability
var names = users
    .Where(u => u.Active)
    .Select(u => u.Name)
    .ToList(); // ToImmutableList() for true immutability

// Immutable record
public record Point(double X, double Y);
```

### Kotlin
```kotlin
// Expression-oriented, immutable by default
val result = items
    .filter { it.isValid() }
    .map { it.compute() }
    .let { transform(it) }

// Sealed class as sum type
sealed class HttpResult
data class Success(val data: Data) : HttpResult()
data class Error(val msg: String) : HttpResult()
```

### Dart
```dart
// Collection methods, immutable records, pattern matching
final processed = items
    .where((x) => x.isValid)
    .map((x) => x.compute())
    .toList(growable: false); // fixed-length = immutable-like

// Record + pattern matching in Dart 3+
(int, String) pair = (1, "a");
switch (pair) {
  case (1, var s) => print(s);
}
```

### Swift
```swift
// Value types by default, map/filter/reduce, optionals
let evens = (0..<100)
    .filter { $0.isMultiple(of: 2) }
    .map { $0 * $0 }

// No nullable — Optionals
func find(_ id: Int) -> User? { ... }
```

### Elixir / Erlang
```elixir
# Pipe operator, immutable data, pattern matching
processed = data
|> Enum.filter(& &1.active)
|> Enum.map(&transform(&1))

# Pattern matching, no assignment mutation
{ :ok, result } = do_something()
```

### OCaml / ReasonML
```ocaml
(* Already functional — just stay in its sweet spot *)
let processed =
  data
  |> List.filter (fun x -> x.Valid)
  |> List.map (fun x -> compute x)
```

### Zig
```zig
// Zig is low-level but still supports functional patterns
const processed = for (items) |item| {
    if (isValid(item)) break compute(item);
} else default_value;

// Prefer destructuring and const
const x: u32 = 42; // const by default, var is explicit
```

### C
```c
// C is hardest — but structure helps
// Use function pointers, structs (immutable by convention)
// Move loops into named functions: map_int(), filter_int()
int mapped[100];
map_int(mapped, source, len, square); // named operation, reusable
// Pure functions: all state via parameters, no globals
```

---

## Review Checklist (Universal)

When reviewing code in ANY language, check for these violations:

- [ ] Any `for` / `while` / `loop` that could be `map`/`filter`/`reduce`?
- [ ] Any mutable variable reassigned after initialization?
- [ ] Any `null` / `nil` / `undefined` that could be `Option<T>`?
- [ ] Any `throw` for control flow instead of `Result<T,E>`?
- [ ] Any side effects (print/log/file/network) mixed with business logic?
- [ ] Any global mutable state?
- [ ] Any magic numbers / stringly-typed code?
- [ ] Any boolean overloaded parameters that should be an enum?
- [ ] Any `if` without an `else` / missing case in a switch?
- [ ] Any mutation of function arguments?
- [ ] Any functions called `get*` that perform I/O?
- [ ] Any early returns that could be an expression?

---

## When Pragmatism Wins

FP is the default; pragmatism is the exception. Acceptable trade-offs:

1. **Performance**: A manually unrolled loop in a hot path — only after profiling.
2. **FFI/Interop**: Mutating a C struct because the foreign API demands it.
3. **Maximal constraints**: Embedded systems, GPU kernels, WASM with no alloc.
4. **Language ceiling**: Go's `for range` is unavoidable; wrap it in a pure function.
5. **Scripting**: A 5-line shell script replacing 50 lines of "pure" pipe plumbing.

When you compromise, **document why** with a comment.
