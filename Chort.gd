extends Node2D

export var SENSE_RADIUS: int = 200
export(Array, Resource) var scenes

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play("idle")
	$Sense/SenseRadius.shape.radius = SENSE_RADIUS
	print(scenes[0])

func _on_Sense_body_entered(body):
	if body.is_in_group("hero"):
		print("The magnificient hero ", body, " entered")
		$Sprite.play("run")

func _on_Sense_body_exited(body):
	if body.is_in_group("hero"):
		print("The magnificient hero ", body, " entered")
		if $Sprite.is_playing():
			$Sprite.stop()
		$Sprite.play("idle")
