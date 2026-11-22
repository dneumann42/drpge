import std/[tables, hashes]

type
  PointOfInterestId* = distinct string
  
  PointOfInterest* = object
    id*: PointOfInterestId
    name*: string
    case
    of Building:
      discard
    of TownCenter:
      discard
    of Market:
      discard

  SettlementId* = distinct string

  SettlementKind* = enum
    Camp
    Town
    City

  Settlement* = object
    id: SettlementId
    kind: SettlementKind
    name: string
    description: string
    points: seq[PointOfInterest]

  World* = object
    settlements: Table[SettlementId, Settlement]

  WorldLocation* = tuple[
    settlement: SettlementId,
    poi: PointOfInterestId
  ]
    
proc hash*(x: SettlementId): Hash {.borrow.}
proc `==`*(a, b: SettlementId): bool {.borrow.}

proc hash*(x: PointOfInterestId): Hash {.borrow.}
proc `==`*(a, b: PointOfInterestId): bool {.borrow.}

proc init*(T: typedesc[World]): T =
  result = T()

proc init*(T: typedesc[Settlement], id: SettlementId, kind: SettlementKind, name: string): T =
  result = T(id: id, kind: kind, name: name)

proc add*(world: var World, settlement: Settlement) =
  world.settlements[settlement.id] = settlement

proc add*(
  world: var World,
  settlementId: SettlementId,
  poi: PointOfInterest) {.raises: [CatchableError].} =
  if not world.settlements.hasKey(settlementId):
    raise CatchableError.newException("Settlement does not exist: " & settlementId.string)
  world.settlements[settlementId].points.add(poi)
