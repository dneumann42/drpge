import std/[sysrand, strutils]

proc generateId*(): string {.raises: [CatchableError].} =
  var bytes: array[16, byte]
  if not urandom(bytes):
    raise IOError.newException("Failed to generate random ID")
  result = newStringOfCap(32)
  for b in bytes:
    result.add(toHex(b, 2).toLowerAscii())
