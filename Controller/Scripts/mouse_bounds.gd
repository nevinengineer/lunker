extends Area2D


onready var collision_shape = $CollisionShape2D

var shape : Shape2D

signal on_angle_change(angle)

func _ready():
	shape = collision_shape.get_shape()


func _on_MouseController_on_initial_position(mouse_position):
	position = mouse_position

func _on_MouseController_on_mouse_move(event):
	position.x = event.position.x
	
	if event.position.y > position.y + (shape.extents.y):
		position.y = event.position.y - (shape.extents.y)
	
	if event.position.y < position.y - (shape.extents.y):
		position.y = event.position.y + (shape.extents.y)
	
	var mouse_pos_viewport_y = get_viewport().get_mouse_position().y
	
	var angle = (position.y - mouse_pos_viewport_y) / 1.25
	
	angle = clamp(angle, -120.0, 45.0)
	
	emit_signal("on_angle_change", angle)
	

