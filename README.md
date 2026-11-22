# drpge
Dustin's role-playing game engine is a Nim library. Its first rule,
`applyDamage`, calculates remaining health and clamps it at zero.

With Nim 2.0 or newer and Make installed, run the example and test suite:

```sh
make run
make test
```

Add `drpge` as a dependency in your Nimble project to use the library.

```nim
import drpge

let remainingHealth = applyDamage(20'u, 7'u)
```
