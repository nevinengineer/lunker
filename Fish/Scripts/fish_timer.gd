extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()


signal on_strike_timer_timeout

signal on_force_timer_timeout

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func strike_timer():
	self.start(rng.randf_range(0.3, 2.0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FishTimer_timeout():
	pass # Replace with function body.
