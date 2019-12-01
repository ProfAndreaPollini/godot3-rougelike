extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var direction setget , _get_direction

var VELOCITY : float = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		direction += Vector2.UP
	if Input.is_action_pressed("ui_down"):
		direction += Vector2.DOWN
		
	move_and_collide(direction.normalized()*delta*VELOCITY)
	
func _get_direction():
	return Vector2.UP.rotated(rotation)