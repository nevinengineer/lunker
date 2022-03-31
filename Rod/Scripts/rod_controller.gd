extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal on_mouse_move(event)

func _unhandled_input(event:InputEvent)->void:
	if event is InputEventMouseMotion:
#		print(event.speed)
		emit_signal("on_mouse_move", event)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



	


func _on_Rod_on_rod_move(target):
	pass
#	print(target.position)
