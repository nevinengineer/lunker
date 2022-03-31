extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var ROD = $Loadout/Rod
onready var REEL = $Loadout/Reel
onready var LINE = $Loadout/Line
onready var BAIT = $Loadout/BaitKinematic

var Fnet = Vector2.ZERO


var BAIT_MASS = BAIT.convert_bait_mass()



const GRAVITY_VECTOR := Vector2(0, 9.8)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


