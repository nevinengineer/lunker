extends Node

signal on_initial_position(mouse_position)
signal on_mouse_move(event)
signal on_wheel_move(direction)
signal on_new_angle(angle)

func _unhandled_input(event:InputEvent)->void:
	if event is InputEventMouseMotion:
#		print(event.speed)
		emit_signal("on_mouse_move", event)

# Called when the node enters the scene tree for the first time.
func _ready():
	var mouse_position = get_viewport().get_mouse_position()
	emit_signal("on_initial_position", mouse_position)

func _process(delta):
	if Input.is_action_just_released("wheel_up"):
		emit_signal("on_wheel_move", "up")
	if Input.is_action_just_released("wheel_down"):
		emit_signal("on_wheel_move", "down")
		
func _on_MouseBounds_on_angle_change(angle):
	emit_signal("on_new_angle", angle/2.0)
