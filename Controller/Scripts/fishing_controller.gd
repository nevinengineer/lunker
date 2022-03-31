extends Node

enum State {UNCASTABLE, CASTABLE, CASTING, IN_FLIGHT, DROPPED, REELING, IDLE, STRIKING, SETTING, FIGHTING, LANDED, LOST}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var observer_state : int

var cast_power := 0.5
var time := 0.0
var cast_meter_speed := 0.1
signal on_cast
signal on_reeling(reeling)
signal on_load(direction)
signal on_set


func _get_input():
#	if Input.is_action_just_pressed("ui_select"):
#		emit_signal("cast", cast_power)
	if Input.is_action_just_pressed("ui_up"):
		emit_signal("on_load", "increase")
	if Input.is_action_just_pressed("ui_down"):
		emit_signal("on_load", "decrease")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_get_input()
	match observer_state:
		State.UNCASTABLE:
#			time = 0.0
			pass
		State.CASTABLE:
#			time += delta
#			cast_power = abs(sin(cast_meter_speed * (2 * PI) * time))
#			print(100 * abs(cast_power))
			if Input.is_action_just_pressed("left_click"):
#				print(cast_power)
				emit_signal("on_cast", cast_power)
		State.CASTING:
			pass
		State.IN_FLIGHT:
			if Input.is_action_just_pressed("left_click"):
				emit_signal("on_reeling", true)
		State.DROPPED:
			if Input.is_action_just_pressed("left_click"):
				emit_signal("on_reeling", true)
		State.REELING:
			if Input.is_action_just_released("left_click"):
				emit_signal("on_reeling", false)
		State.IDLE:
			if Input.is_action_just_pressed("left_click"):
				emit_signal("on_reeling", true)
		State.STRIKING:
			if Input.is_action_just_pressed("left_click"):
				emit_signal("on_set")
		State.SETTING:
			#TODO possibly implement logic for good or bad setting of the hook
			pass
		State.FIGHTING:
			pass
#			if Input.is_action_just_pressed("left_click"):
#				emit_signal("on_reeling", true)
		State.LANDED:
			pass
		State.LOST:
			pass


func _on_PhysicsObserver_on_state_change(state):
	observer_state = state


func _on_MouseController_on_wheel_move(direction):
	if observer_state == State.CASTABLE:
		if direction == "up":
			cast_power += 0.1
		if direction == "down":
			cast_power -= 0.1
		
		cast_power = clamp(cast_power, 0.1, 1.0)
		print(cast_power)
		
