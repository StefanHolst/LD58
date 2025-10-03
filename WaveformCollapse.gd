extends Node


enum Direction {
	Top,
	Right,
	Down,
	Left
}

@abstract class Tile:
	var type: String
	@abstract func is_Compatible(other: Tile, direction: Direction) -> bool;

class test extends Tile:
	func is_Compatible(other: Tile, direction: Direction) -> bool:
		print("", other, direction)
		return false

class Generator:
	func AllTiles() -> Array[Variant.Type]:
		return [typeof(test)]
