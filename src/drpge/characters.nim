import std/[hashes]

import ids

type
  CharacterId* = distinct string

  Character* = object
    id*: CharacterId
    name*, surname*: string

proc hash*(x: CharacterId): Hash {.borrow.}
proc `==`*(a, b: CharacterId): bool {.borrow.}

proc genCharacterId*(): CharacterId =
  result = generateId().CharacterId

proc init*(T: typedesc[Character]): T {.raises: [CatchableError].} =
  result = T(id: genCharacterId())
