extends Node2D

enum State {UNCASTABLE, CASTABLE, CASTING, IN_FLIGHT, DROPPED, REELING, IDLE, STRIKING, SETTING, FIGHTING, LANDED, LOST}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var REEL_SPEED : float # in rotations of the handle per second (RPS)
export var MAX_REEL_SPEED : float # in rotations of the handle per second (RPS)
export var RPT : float #inches of line retreived per full handle revolution
export var MAX_REEL_DRAG : float
export var DRAG : float # in lbf
export var CAPACITY_MONO: float # in yards
export var CAPACITY_TEST_MONO: float # pound test of mono line used for capacity measurement
export var CAPACITY_BRAID: float # in yards
export var CAPACITY_TEST_BRAID: float # pound test of braided line used for capacity measurement
export var GEAR_RATIO: float # one full revolution of the handle rotates the spool this many times

const LBF_TO_N := 4.448 # 1 LBF = 4.448 N
const YARD_TO_M := 1.09361 # 1 M = 1.09361 YD
const IN_TO_M := 39.37 # 1 M = 39.37 inches

var reel_sprite = preload("res://Reel/Scenes/ReelSprite.tscn")

var bail_open := false
var handle_rotation := 0.0
var line_recovered := 0.0
var angular_velocity := 0.0

var spool_rotation : float
var estimated_spool_radius : float # in meters
var meters_per_turn : float
var drag_newtons : float

var bait_velocity : Vector2
var observer_state : int

signal on_bail_flipped(bail_open)
signal on_reeling(reel_speed, handle_rotation, tan_velocity, tan_acceleration)
signal on_reel_ready(reel_sprite)

func _flip_bail():
	bail_open = not bail_open
	emit_signal("on_bail_flipped", bail_open)

func _convert_capacity():
	return {
		"mono_capacity": CAPACITY_MONO / YARD_TO_M, 
		"braid_capacity" : CAPACITY_BRAID / YARD_TO_M
		}

# Called when the node enters the scene tree for the first time.
func _ready():
	meters_per_turn = RPT / IN_TO_M
	drag_newtons = DRAG * LBF_TO_N
	estimated_spool_radius = meters_per_turn / GEAR_RATIO
	
	emit_signal("on_reel_ready", reel_sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var old_handle_rotation = handle_rotation
	var old_angular_velocity = angular_velocity
#	var old_spool_rotation = handle_rotation * GEAR_RATIO
	match observer_state:
		State.UNCASTABLE:
			pass
		State.CASTABLE:
#			_flip_bail()
			emit_signal("on_bail_flipped", true)
		State.CASTING:
			pass
		State.IN_FLIGHT:
			var delta_theta = (bait_velocity.x / estimated_spool_radius) * delta
			spool_rotation += delta_theta
			var line_stripped = (spool_rotation / GEAR_RATIO) * meters_per_turn
#			print(line_stripped)
		State.DROPPED:
			emit_signal("on_bail_flipped", true)
		State.REELING:
#			_flip_bail()
			emit_signal("on_bail_flipped", false)
			handle_rotation += (2*PI) * delta * REEL_SPEED
			var delta_theta = handle_rotation - old_handle_rotation
			angular_velocity = delta_theta / delta
			var angular_acceleration = (old_angular_velocity - angular_velocity) / delta
			var tan_velocity = angular_velocity * estimated_spool_radius
			var tan_acceleration = angular_acceleration * estimated_spool_radius
#			print("total handle turns: %s" % [handle_rotation/(2*PI)])
			var line_recovered = handle_rotation/(2*PI) * meters_per_turn
#			reel_force.x = (spool_torque / (REEL_SPOOL_DIAMETER/2)) * cos(line_angle)
#			reel_force.y = (spool_torque / (REEL_SPOOL_DIAMETER/2)) * sin(line_angle)
#			print("tangential velocity: %f" % [tan_velocity])
#			print("angular vel: %f, angular acc: %f, tangential acc: %f" %[angular_velocity, angular_acceleration, tan_acceleration])
			emit_signal("on_reeling", REEL_SPEED, handle_rotation, tan_velocity, tan_acceleration)
		State.IDLE:
			pass
		State.STRIKING:
			pass
		State.SETTING:
			pass
		State.FIGHTING:
			pass
		State.LANDED:
			handle_rotation = handle_rotation - old_handle_rotation
		State.LOST:
			pass

func _on_PhysicsObserver_on_state_change(state):
	observer_state = state


func _on_MouseController_on_wheel_move(direction):
	
	if observer_state != State.CASTABLE:
		if direction == "up":
			REEL_SPEED += 0.5
		if direction == "down":
			REEL_SPEED -= 0.5
	
	REEL_SPEED = clamp(REEL_SPEED, 0.5, MAX_REEL_SPEED)
#	print(REEL_SPEED)


func _on_BaitKinematic_on_move(target):
	bait_velocity = target.velocity


#func _on_Rod_on_reel_seat_defined(reel_seat_position, reel_seat_rotation):
#	print(reel_seat_position)
#	$ReelSprite.global_position.x = reel_seat_position.x + 32
#	$ReelSprite.global_position.y = reel_seat_position.y + 64
#	$ReelSprite.global_rotation = reel_seat_rotation
#	global_position = $ReelSeatPosition2D.global_position
#	rotation = $ReelSeatPosition2D.rotation
