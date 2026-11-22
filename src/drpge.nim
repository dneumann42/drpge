import std/[tables, sequtils, random]

import drpge/[characters]
export characters

type
  DRPGE* = object
    characters: Table[CharacterId, Character]
    characterTurnOrder: seq[CharacterId]

proc init*(T: typedesc[DRPGE]): T =
  result = T()

proc spawn*(rpg: var DRPGE): CharacterId =
  discard

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
    let characterId = rpg.characterTurnOrder.pop()
    if rpg.onCharacter(characterId):
      continue
    rpg.stepTurn(characterId)

proc beginTurn*(rpg: var DRPGE) =
  rpg.updateTurnOrder()

proc finishTurn*(rpg: var DRPGE) =
  discard
