import std/[tables, sequtils, random]

import drpge/[characters, worlds]
export characters, worlds

type
  DRPGE* = object
    world: World
    characters: Table[CharacterId, Character]
    characterTurnOrder: seq[CharacterId]
    characterWorldLocations: Table[CharacterId, WorldLocation]

proc init*(T: typedesc[DRPGE]): T =
  result = T()

proc add*(rpg: var DRPGE, settlement: Settlement) =
  rpg.world.add(settlement)

proc add*(rpg: var DRPGE, settlementId: SettlementId, poi: PointOfInterest) =
  rpg.world.add(settlementId, poi)

proc place*(rpg: var DRPGE, characterId: CharacterId, loc: WorldLocation) {.raises: [CatchableError].} =
  if not rpg.characters.hasKey(characterId):
    raise CatchableError.newException("Character does not exist: " & characterId.string)
  rpg.characterWorldLocations[characterId] = loc

proc spawn*(rpg: var DRPGE): CharacterId =
  var chr = Character.init()
  rpg.characters[chr.id] = chr
  result = chr.id

proc updateTurnOrder*(rpg: var DRPGE) =
  # Currently this randomizes the turn order list, eventually it will
  # take into account the characters speed, speedier characters take turns first
  rpg.characterTurnOrder = rpg.characters.keys().toSeq()
  shuffle(rpg.characterTurnOrder)

proc isTurn*(rpg: var DRPGE, characterId: CharacterId): bool =
  rpg.characterTurnOrder[^1] == characterId

proc stepTurn*(rpg: var DRPGE, characterId: CharacterId) =
  discard

proc processCharacterTurns*(rpg: var DRPGE, onCharacter: proc(rpg: var DRPGE, id: CharacterId): bool) =
  while rpg.characterTurnOrder.len > 0:
    let characterId = rpg.characterTurnOrder[^1]
    if rpg.onCharacter(characterId):
      discard rpg.characterTurnOrder.pop()
      continue
    discard rpg.characterTurnOrder.pop()
    rpg.stepTurn(characterId)

proc beginTurn*(rpg: var DRPGE) =
  rpg.updateTurnOrder()

proc finishTurn*(rpg: var DRPGE) =
  discard
