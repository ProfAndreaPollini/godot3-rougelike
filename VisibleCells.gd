extends TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var x_cells
var y_cells

export var X_FOV_SIZE : int = 5
export var Y_FOV_SIZE : int = 5

# Called when the node enters the scene tree for the first time.
func init_visile_cells_tilemap(x_cells,y_cells):
	self.x_cells = x_cells
	self.y_cells = y_cells
	var hidden_tile = tile_set.find_tile_by_name("hidden")
	for x in range(x_cells):
		for y in range(y_cells):
			set_cell(x,y,hidden_tile)
			
func update_visibile_cells(cell,direction):
	for x in range(max(0,cell.x-X_FOV_SIZE),min(x_cells,cell.x+X_FOV_SIZE)):
		for y in range(max(0,cell.y-Y_FOV_SIZE),min(y_cells,cell.y+Y_FOV_SIZE)):
			set_cell(x,y,-1)