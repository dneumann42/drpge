import std/[hashes]

type
  CharacterId* = distinct string

  Character* = object
    id: CharacterId
    name, surname: string

proc hash*(x: CharacterId): Hash {.borrow.}
proc `==`*(a, b: CharacterId): bool {.borrow.}

proc init*(T: typedesc[Character]): T =
  result = T()
