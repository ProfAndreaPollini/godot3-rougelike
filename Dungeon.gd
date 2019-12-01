extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var hero = $Hero/Body 
onready var map = $DungeonMap
onready var visible_cells = $VisibleCells

# Called when the node enters the scene tree for the first time.
func _ready():
	map.generate_rooms_and_corridors()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var map_cell = map.world_to_map(hero.global_position) # get hero cell
	#print(map_cell)
	visible_cells.update_visibile_cells(map_cell,hero.direction)



func _on_TileMap_map_generated():
	#print(map.rooms[0].position)
	visible_cells.init_visile_cells_tilemap(map.X_CELLS,map.Y_CELLS)
	hero.global_position = 16 * (map.rooms[0].position + 0.5 * map.rooms[0].size )
	$Monsters/MonsterSpawner.global_position = 16 * (map.rooms[1].position + 0.5 * map.rooms[1].size )
	$Monsters/MonsterSpawner.spawn()
