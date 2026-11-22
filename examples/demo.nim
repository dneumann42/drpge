import std/[terminal]

import drpge

type
  Game = object
    running: bool
    rpg: DRPGE

proc stepPlayerTurn*(rpg: var DRPGE, playerId: CharacterId) =
  discard

proc run(game: var Game) =
  let playerId = game.rpg.spawn()
  
  let townA = SettlementId"a"
  let pubA = PointOfInterestId"pub"

  game.rpg.add Settlement.init(townA, Town, "AAA")
  game.rpg.add townA, Building(id: pubA, name: "Ye Hairy Leg")
  game.rpg.add Settlement.init(SettlementId"b", City, "BBB")
  
  game.rpg.place playerId, (townA, pubA)

  while game.running:
    game.rpg.beginTurn()
    game.rpg.processCharacterTurns() do(rpg: var DRPGE, id: CharacterId) -> bool:
      if id != playerId or not rpg.isTurn(playerId):
        return false
      rpg.stepPlayerTurn(playerId)
      result = true
    game.rpg.finishTurn()

when isMainModule:
  var game = Game(running: true, rpg: DRPGE.init())
  game.run()
