extends Node

const TILE_CENTER = 0
const TILE_HORIZONTAL_CORRIDOR = 1
const TILE_VERTICAL_CORRIDOR = 2
const TILE_BLIND_TOP = 3
const TILE_BLIND_RIGHT = 4
const TILE_BLIND_BOTTOM = 5
const TILE_BLIND_LEFT = 6
const MAX_TILES = 6

class Tile:
	var x = 0
	var y = 0
	var type = -1
	var options = range(MAX_TILES) # avaiable tile options
	
	func _init(_x: int, _y: int, _type: int):
		x = _x
		y = _y
		type = _type


class Generator:
	var map = {} # all the tiles
	var width = 10
	var height = 10
	
	func _init(_height: int, _width: int):
		height = _height
		width = _width
		#_gen(width/2, height/2)
		
		var x = width/2
		var y = height/2
		
		# create start tile
		var startTile = Tile.new(x, y, TILE_CENTER)
		map[[x,y]] = startTile
		
		# generate the map
		while true:
			# find next tile with least options
			var tile = _get_next_tile(x, y)
			var available_tiles = _get_available_tiles(tile)

			# If there are multiple options pick one at random
			if len(available_tiles) > 1:
				# pick a random tile
				tile.type = available_tiles[0] # TODO: random..
			elif len(available_tiles) == 1:
				# otherwise just pick the first one
				tile.type = available_tiles[0]
			else:
				# No compatible tile
				pass
			
			# Put the tile in the map
			map[[x,y]] = tile
		
		# print the map
		for _y in height:
			for _x in width:
				var tile = map[[_x,_y]]
				print("{0} [{1}, {2}]", tile.type, _x, _y)
		
	func _gen(x: int, y: int) -> bool: # returns if it succeeded
		# Determines what this tile will be...
		
		var tile = Tile.new(x, y, -1)
		var available_tiles = _get_available_tiles(tile)
		
		if len(available_tiles) > 1:
			# pick a random tile
			tile.type = available_tiles[0] # TODO: random..
		elif len(available_tiles) == 1:
			# otherwise just pick the first one
			tile.type = available_tiles[0]
		else:
			# No compatible tile
			return false
		
		# Put the tile in the map
		map[[x,y]] = tile
		
		## Go through each neighbour
		## TODO: Should be the one with least options
		#for dir in range(4):
			#var point = _get_neighbour_coordinate(tile, dir)
			#if point == null: # no neighbour - edge
				#continue
			#if map.has([point[0], point[1]]):
				#continue
			#if _gen(point[0], point[1]) == false:
				## fuck...
				#print("Failed to generate tile")
				#pass

		return true
	
	func _get_next_tile(xStart: int, yStart: int) -> Vector2:
		var minX = xStart
		var minY = yStart
		var minOptions = MAX_TILES

		for y in height:
			for x in width:
				var tile = map.get([x, y])
				if tile == null:
					continue
				if tile.type >= 0:
					continue
				var options = len(tile.options)
				if options < minOptions:
					minOptions = len(tile.options)
					minX = x
					minY = y
				if options == 1: # we found a candidate that only has 1 option
					break

		return map.get([minX, minY])
	
	func _get_available_tiles(thisTile: Tile) -> Array:
		# for each of the tile options, go through each neighbour and check if it's compatible
		var available = range(MAX_TILES)

		for dir in range(4): # the 4 directions
			var neighbour = _get_neighbour(thisTile, dir)
			if neighbour == null: # no tile for neighbour
				continue
			for tileType in range(len(available)):
				if _is_compatible(thisTile, dir, neighbour) == false:
					available.erase(tileType)
		
		return available
	
	func _get_neighbour(tile: Tile, dir: int):
		var point = _get_neighbour_coordinate(tile, dir)
		if point == null:
			return null
		
		return map.get([point[0], point[1]])

	func _get_neighbour_coordinate(tile: Tile, dir: int):
		if dir == 0: # top
			if tile.y > 0:
				return [tile.x, tile.y-1]
		elif dir == 1: # right
			if tile.x < width - 1:
				return [tile.x - 1, tile.y]
		elif dir == 2: # bottom
			if tile.y < height - 1:
				return [tile.x, tile.y + 1]
		elif dir == 3: # left
			if tile.x > 0:
				return [tile.x - 1, tile.y]
		
		return null

	func _is_compatible(tile: Tile, direction: int, other: Tile) -> bool:
		return true
	
