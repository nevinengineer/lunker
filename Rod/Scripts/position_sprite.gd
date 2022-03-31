extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var yellow_sprite = preload("res://Water/Sprites/joint_yellow.png")
var blue_sprite = preload("res://Water/Sprites/joint_blue.png")
var red_sprite = preload("res://Water/Sprites/joint_red.png")
var white_sprite = preload("res://Water/Sprites/joint_white.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_color(color):
	if color == "red":
		set_texture(red_sprite)
	if color == "blue":
		set_texture(blue_sprite)
	if color == "yellow":
		set_texture(yellow_sprite)
	if color == "white":
		set_texture(white_sprite)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
