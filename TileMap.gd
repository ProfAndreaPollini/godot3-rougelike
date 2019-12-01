extends TileMap

signal map_generated
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum  {BACKGROUND,DEBUG,WALL_TILE,FLOOR_TILE1,FLOOR_TILE2,FLOOR_TILE3,FLOOR_TILE4,FLOOR_TILE5,FLOOR_TILE6}
enum TileTypes {WALL,FLOOR}

var tiles : Dictionary = {} 
var tile_types : Dictionary = {} 

export var X_CELLS : int = 110
export var Y_CELLS : int = 80
export var MAX_ROOMS : int = 10
export var MIN_ROOM_SIZE : int  = 5
export var MAX_ROOM_SIZE : int  = 15

var rooms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#tiles[DEBUG] = tile_set.find_tile_by_name("debug")
	tiles[WALL_TILE] = tile_set.find_tile_by_name("wall1")
	tiles[FLOOR_TILE1] = tile_set.find_tile_by_name("floor1")
	tiles[FLOOR_TILE2] = tile_set.find_tile_by_name("floor2")
	tiles[FLOOR_TILE3] = tile_set.find_tile_by_name("floor3")
	tiles[FLOOR_TILE4] = tile_set.find_tile_by_name("floor4")
	tiles[FLOOR_TILE5] = tile_set.find_tile_by_name("floor5")
	tiles[FLOOR_TILE6] = tile_set.find_tile_by_name("floor6")
	#tiles[BACKGROUND] = tile_set.find_tile_by_name("background")
	tile_types[TileTypes.WALL] = [tiles[WALL_TILE]]
	tile_types[TileTypes.FLOOR] = [tiles[FLOOR_TILE1],tiles[FLOOR_TILE2],tiles[FLOOR_TILE3],tiles[FLOOR_TILE4],tiles[FLOOR_TILE5],tiles[FLOOR_TILE6]]
	print(tile_types[TileTypes.WALL])
	randomize()
	
	

func _get_random_tile(tile_type) :
	var tiles = tile_types[tile_type]
	var selected = tiles[randi() % (tile_types[tile_type].size())]
	return selected


func generate_rooms_and_corridors():
	for x in range(X_CELLS):
		for y in range(Y_CELLS):
			set_cell(x,y,tiles[WALL_TILE])
	for i in range(MAX_ROOMS):
		var w = int(rand_range(MIN_ROOM_SIZE,MAX_ROOM_SIZE))
		var h =  int(rand_range(MIN_ROOM_SIZE,MAX_ROOM_SIZE))
		
		var x = int(rand_range(1,X_CELLS - w)) -1
		var y = int(rand_range(1,Y_CELLS - h)) -1
		var ok = true
		var new_room = Rect2(x,y,w,h)
		for room in rooms:
			if new_room.intersects(room):
				ok = false
				break
		if ok:		
			_apply_room(new_room)	
			rooms.append(new_room)	
			if len(rooms) >= 1:
				var room_from_center = _room_center(rooms[len(rooms)-2])
				var room_to_center = _room_center(new_room)
				if randi() % 2 == 0:
				#prev_x, new_x, prev_y
					_h_tunnel(room_from_center.x, room_to_center.x,room_from_center.y)
					_h_tunnel(room_from_center.x, room_to_center.x,room_from_center.y+1)
					_v_tunnel(room_from_center.y, room_to_center.y,room_to_center.x)
					_v_tunnel(room_from_center.y, room_to_center.y,room_to_center.x+1)
				else:
			#		_v_tunnel(rooms[len(rooms)-2],new_room)
			#		_h_tunnel(rooms[len(rooms)-2],new_room)
					_v_tunnel(room_from_center.y, room_to_center.y,room_from_center.x)
					_v_tunnel(room_from_center.y, room_to_center.y,room_from_center.x+1)
					_h_tunnel(room_from_center.x, room_to_center.x,room_to_center.y)
					_h_tunnel(room_from_center.x, room_to_center.x,room_to_center.y+1)
	
	# cleanup rooms
	var cells_to_delete = []
	
	for x in range(X_CELLS):
		for y in range(Y_CELLS):
			#if 	close_to_cell_types(x,y,tile_types[TileTypes.WALL]):
				#print(tile_types[TileTypes.WALL]," ",get_cell(x,y)," -> ",close_to_cell_types(x,y,tile_types[TileTypes.WALL]))
			if 	tile_types[TileTypes.WALL].has(get_cell(x,y)) and close_to_cell_types(x,y,tile_types[TileTypes.WALL]):
					#print(".")
					cells_to_delete.append(Vector2(x,y))
	for cell  in cells_to_delete:#
		set_cellv(cell,-1)
	emit_signal("map_generated")

func neigh(x,y):
	var ret = ""
	for i in [-1,0,1]:
		for j in [-1,0,1]:	
			ret = ret +"("+ str(x+i) +", "+str(y+j)+") ->  " + str(get_cell(x+i,y+j))
	return ret
func close_to_cell_types(x,y,cell_types) -> bool:
	var all_found = true
	var n = -1
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if x+i != x and y+j != y:
				#print(cell_types," ",neigh(x+i,y+j))
				if not cell_types.has(get_cell(x+i,y+j)):
					return false
				else:
					n = n+1
	#if n > 6:
	#	print("(",x,", ",y,") -> ",n , "[ "+ neigh(x,y)+" ]")	
	
	return true

func _room_center(room):
	return room.position + 0.5 * room.size	

func _h_tunnel(x1,x2,y):
	for x in range(min(x1,x2),max(x1,x2)):
		set_cell(x,y,_get_random_tile(TileTypes.FLOOR))
	
func _v_tunnel(y1,y2,x):
	for y in range(min(y1,y2),max(y1,y2)):
		set_cell(x,y,_get_random_tile(TileTypes.FLOOR))
	
func _apply_room(room: Rect2) -> void:
	for x in range(room.position.x,room.end.x):
		for y in range(room.position.y,room.end.y):
			#print(_get_random_tile(TileTypes.FLOOR))
			set_cell(x,y,_get_random_tile(TileTypes.FLOOR))#tiles[Tiles.FLOOR_TILE1])#tiles[_get_random_tile(TileTypes.FLOOR)])
			
#func generate():
#	var wall_tile_id = tile_set.find_tile_by_name("wall1")
#	var floor_tile_id = tile_set.find_tile_by_name("floor1")
#
#	for x in range(X_CELLS):
#		for y in range(Y_CELLS):
#			set_cell(x,y,floor_tile_id)
#
#	for x in range(X_CELLS):
#		set_cell(x,0,wall_tile_id)
#		set_cell(x,Y_CELLS-1,wall_tile_id)
#	for y in range(Y_CELLS):
#		set_cell(0,y,wall_tile_id)
#		set_cell(X_CELLS-1,y,wall_tile_id)
#
#	for i in range(400):
#		var x = randi() % X_CELLS
#		var y = randi() % Y_CELLS
#		set_cell(x,y,wall_tile_id)
		
		