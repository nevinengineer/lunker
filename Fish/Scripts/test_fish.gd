extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum State {UNCASTABLE, CASTABLE, CASTING, IN_FLIGHT, DROPPED, REELING, IDLE, STRIKING, SETTING, FIGHTING, LANDED, LOST}


var rng = RandomNumberGenerator.new()
var observer_state : int

signal on_strike
signal on_hook
signal on_fight(force)
signal on_miss

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

func strike():
	emit_signal("on_strike")
	var time = rng.randf_range(0.5, 1.5)
	$StrikeTimer.start(time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	match observer_state:
		State.UNCASTABLE:
			pass
		State.CASTABLE:
			pass
		State.CASTING:
			pass
		State.IN_FLIGHT:
			pass
		State.DROPPED:
			pass
		State.REELING:
			pass
		State.IDLE:
			if Input.is_action_just_pressed("ui_select"):
				strike()
		State.STRIKING:
			pass
		State.SETTING:
			emit_signal("on_hook")
		State.FIGHTING:
			pass
			if $FightTimer.time_left > 0:
				pass
			else:
				var time = rng.randi_range(1,5)
				$FightTimer.start(time)
		State.LANDED:
			pass
		State.LOST:
			pass


func _on_StrikeTimer_timeout():
	$StrikeTimer.stop()
	if observer_state != State.FIGHTING:
		emit_signal("on_miss")


func _on_PhysicsObserver_on_state_change(state):
	observer_state = state


func _on_FightTimer_timeout():
	if observer_state == State.FIGHTING:
		var force = rng.randi_range(0, 100)
		print(force)
		emit_signal("on_fight", force)
