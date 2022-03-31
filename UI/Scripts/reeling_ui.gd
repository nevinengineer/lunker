extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MouseController_on_new_angle(angle):
	print(angle)


func _on_Reel_on_reeling(reel_speed, handle_rotation, tan_velocity, tan_acceleration):
	$"VBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer/Control/Reel GUI".rotation = handle_rotation
