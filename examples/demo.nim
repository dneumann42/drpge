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
