extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#var velocity := Vector2.ZERO
var cast_power := 0.5
var time := 0.0
var cast_meter_speed := 0.1
var velocity = Vector2.ZERO

#var velocity = Vector2.ZERO
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
#
#
### Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):


func _physics_process(delta):
	time += delta
	cast_power = 5 * (sin(cast_meter_speed * (2 * PI) * time))
	velocity.y = cast_power
	
	move_and_collide(velocity)
	print(velocity.y)
	
