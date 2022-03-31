extends KinematicBody2D

enum State {UNCASTABLE, CASTABLE, CASTING, IN_FLIGHT, DROPPED, REELING, IDLE, STRIKING, SETTING, FIGHTING, LANDED, LOST}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var bait_mass : float # oz
export var bait_cd : float
export var bait_length : float # cm
export var height_ratio : float

onready var camera = $Camera2D

const TAG := "BaitKinematic"
const GRAVITY_VECTOR = Vector2(0, 9.8) # y is positive in the downward direction
const OZ_TO_KG = 35.274 # 1 kg = 35.274 oz

var velocity := Vector2.ZERO
var proj_velocity := Vector2.ZERO
var proj_gravity := 0.0
var rod_tip : Vector2
var rod : Vector2
var angle_to_rod : float

var reel_velocity := Vector2.ZERO

var bait_mass_kg : float

onready var submerged := false

var observer_state : int

signal on_move(target)
#signal on_submerged(submerged)
signal on_castable(castable)
signal on_drop(drop_distance)

func log_message(message):
	print(TAG + ": %s " % [message])

func convert_bait_mass():
	return (bait_mass / OZ_TO_KG)

func in_water():
	submerged = !submerged
#	log_message( "bait is submerged: %s" % [submerged])
#	log_message( "bait is submerged at: %f" % [global_position.x])
#	emit_signal("on_submerged", submerged)

func return_to_rod(delta, speed):
	global_position = lerp(global_position, rod_tip + Vector2(0,120), speed*delta)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("bait")
	bait_mass_kg = bait_mass / OZ_TO_KG
#	log_message( "bait is submerged: %s" % [submerged])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
#	log_message(State.keys()[observer_state])
	
#	print(velocity)

	emit_signal("on_move", self)
	angle_to_rod = position.angle_to_point(rod_tip)

	match observer_state:
		State.UNCASTABLE:
			return_to_rod(delta, 6)
			look_at(rod_tip)
			emit_signal("on_castable", !submerged)
		State.CASTABLE:
			return_to_rod(delta, 10)
			look_at(rod_tip)
			emit_signal("on_castable", !submerged)
		State.CASTING:
			look_at(rod_tip)
		State.IN_FLIGHT:
			camera.zoom = lerp(camera.zoom, Vector2(5.0, 5.0), 2 * delta)
			velocity.y += GRAVITY_VECTOR.y * delta
#			velocity.y += (proj_gravity + GRAVITY_VECTOR.y) * delta
			look_at(rod_tip)
			if submerged:
				emit_signal("on_drop", global_position.x)
		State.DROPPED:
			camera.zoom = lerp(camera.zoom, Vector2(2.0, 2.0), 2 * delta)
			pass
#			log_message( "bait is dropped at: %f" % [global_position.x])
#			if not submerged:
#				velocity.y += GRAVITY_VECTOR.y * delta
#				velocity.y = clamp(velocity.y, 0.0, 50.0)
#			if submerged:
#				velocity.y += 3.0 * delta
#				velocity.y = clamp(velocity.y, 0.0, 20.0)
		State.REELING:
			camera.zoom = lerp(camera.zoom, Vector2(3.0, 3.0), 4 * delta)
			var Fg = bait_mass_kg * GRAVITY_VECTOR
			if not submerged:
			
				velocity.y += GRAVITY_VECTOR.y * delta
				
				velocity.x = - reel_velocity.x
#				velocity.y = velocity.y - reel_velocity.y
				
			if submerged:
				velocity.x = move_toward(velocity.x, -reel_velocity.x, 300*delta)
				velocity.y = move_toward(velocity.y, - reel_velocity.y, 300*delta)
		State.IDLE:
			camera.zoom = lerp(camera.zoom, Vector2(1.0, 1.0), 8*delta)
			velocity.x = move_toward(velocity.x, 0.0, delta)
			if not submerged:
				velocity.y += 9.8 * delta
				velocity.y = clamp(velocity.y, 0.0, 50.0)
			if submerged:
				velocity.y += 3.0 * delta
				velocity.y = clamp(velocity.y, 0.0, 20.0)
		State.STRIKING:
			pass
		State.SETTING:
			pass
		State.FIGHTING:
			pass
		State.LANDED:
			velocity = Vector2.ZERO
#			global_position = lerp(global_position, rod_tip, 3.5*delta)
			look_at(rod_tip)
			return_to_rod(delta, 3)
#			print(global_position.distance_squared_to(rod))
#			print(global_position.distance_squared_to(rod_tip))
			if(global_position.distance_squared_to(rod_tip) <= pow(121, 2)):
#				global_position = lerp(global_position, rod_tip + Vector2(0,120), 5*delta)
				emit_signal("on_castable", true)
		State.LOST:
			pass
	
#	print(velocity.y)
	move_and_collide(velocity)

func _on_PhysicsObserver_on_state_change(state):
#	log_message(State.keys()[state])
	observer_state = state


func _on_Rod_on_rod_tip_move(rod_tip_position):
	rod_tip = rod_tip_position


func _on_Rod_on_catch_area_entered(rod_position):
	rod = rod_position


func _on_Reel_on_reeling(reel_speed, handle_rotation, tan_velocity, tan_acceleration):
	reel_velocity.x = tan_velocity * cos(angle_to_rod)
	reel_velocity.y = tan_velocity * sin(angle_to_rod)



func _on_PhysicsObserver_on_cast(cast_velocity):
#	print(cast_velocity)
	velocity.x = cast_velocity.x
	velocity.y = -cast_velocity.y


func _on_CameraController_on_bait_camera():
	$Camera2D.current = true
