extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_rotation := 0.0
onready var rod_ui_sprite = $HBoxContainer/Control/RodRotationSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	if rod_ui_sprite:
		rod_ui_sprite.rotation_degrees = current_rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rod_ui_sprite:
		rod_ui_sprite.rotation_degrees = current_rotation


func _on_MouseController_on_new_angle(angle):
	current_rotation = angle
