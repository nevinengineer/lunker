extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum State {UNCASTABLE, CASTABLE, CASTING, IN_FLIGHT, DROPPED, REELING, IDLE, STRIKING, SETTING, FIGHTING, LANDED, LOST}

const M_TO_PX := 640.0 # 1 meter = 640 px 
var state : int

var cast_power : float
var launch_angle_radians : float
var bait : KinematicBody2D

signal on_state_change(state)
#signal on_cast(projectile_velocity_x, projectile_velocity_y, projectile_gravity)
signal on_cast(cast_velocity)


func solve_projectile(y_initial, y_target, y_peak, time_to_target):
	var gravity = (-4*(y_initial - 2*y_peak + y_target))/pow(time_to_target, 2)
	var velocity_y = (-(3*y_initial - 4*y_peak + y_target))/time_to_target
	
	return {"gravity": gravity, "velocity_y": velocity_y}

func solve_range(speed, angle, initial_height):
	var projectile_range = ((speed * cos(angle))/9.8) * ((speed * sin(angle)) + sqrt((pow(speed, 2)*pow(sin(angle), 2)) + (2*(9.8)*initial_height)))
	return projectile_range
	
func _change_state(new_state):
	state = new_state
#	print(State.keys()[state])
	emit_signal("on_state_change", state)

# Called when the node enters the scene tree for the first time.
func _ready():
	_change_state(State.CASTABLE)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	match state:
		State.UNCASTABLE:
			pass
		State.CASTABLE:
			pass
#			print("Castable")
		State.CASTING:
#			print("Casting")
#			var cast_power = 1.0 # for testing
			var speed = 50.0 * cast_power
			var y_initial = (bait.global_position.y / M_TO_PX)
			var cast_velocity := Vector2(speed * cos(launch_angle_radians), speed * sin(launch_angle_radians))
			
#			print(launch_angle)
#			print(cos(deg2rad(launch_angle)))
#			var projectile_range = solve_range(speed, launch_angle, y_initial)
			
#			var y_target = 0.0
#			var y_peak = (10.0 * cast_power) + y_initial
#			var time_to_target = 1.0
#			time_to_target = clamp(time_to_target, 1.0, 2.0)
#			var projectile_velocity_x = 20.0 * cast_power
			
#			var projectile = solve_projectile(y_initial, y_target, y_peak, time_to_target)
#			print(projectile)
#			emit_signal("on_cast", projectile_velocity_x, -projectile.velocity_y, projectile.gravity)
			emit_signal("on_cast", cast_velocity)
			_change_state(State.IN_FLIGHT)
			
		State.IN_FLIGHT:
#			print("In Flight")
			pass
		State.DROPPED:
			_change_state(State.IDLE)
		State.REELING:
			pass
		State.IDLE:
			pass
		State.STRIKING:
			pass
		State.SETTING:
			pass
		State.FIGHTING:
			pass
		State.LANDED:
			pass
		State.LOST:
			pass
	


func _on_FishingController_on_cast(power):
	cast_power = power
	_change_state(State.CASTING)


func _on_FishingController_on_reeling(reeling):
#	print(reeling)
	if reeling:
		_change_state(State.REELING)
	if not reeling:
		_change_state(State.IDLE)


func _on_Rod_on_catch_area_entered(rod_position):
	_change_state(State.LANDED)


func _on_BaitKinematic_on_castable(castable):
	if castable:
		_change_state(State.CASTABLE)
	if not castable:
		_change_state(State.UNCASTABLE)


func _on_BaitKinematic_on_move(target):
	bait = target


func _on_BaitKinematic_on_drop(distance):
	print("bait cast %f m" % [distance / 640.0])
	_change_state(State.DROPPED)


func _on_MouseController_on_new_angle(angle):
	launch_angle_radians = deg2rad(abs(angle))
#	print(launch_angle)


func _on_FishingController_on_set():
	print("SETTING")
	_change_state(State.SETTING)
	


func _on_TestFish_on_strike():
	print("STRIKE")
	_change_state(State.STRIKING)



func _on_TestFish_on_miss():
	print("MISS")
	_change_state(State.IDLE)


func _on_TestFish_on_hook():
	print("FIGHTING")
	_change_state(State.FIGHTING)
