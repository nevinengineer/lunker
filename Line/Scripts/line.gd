extends Node2D

enum State {UNCASTABLE, CASTABLE, CASTING, IN_FLIGHT, DROPPED, REELING, IDLE, STRIKING, SETTING, FIGHTING, LANDED, LOST}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var pound_test : float # in lbf required to break line

onready var verlet = $VerletLine
onready var rod_line = $RodLine

var line_out := 0.0

var observer_state : int

var rod_tip : Vector2
var bait_velocity : Vector2
var spool_switch_value := 60
var reeling_time := 0
var spool_line_top := true
var reeling_speed := 1.0

var bail : bool



const LBF_TO_N := 4.44822 # 1 lbf = 4.44822 N
const PX_TO_M := 640 # 640 px = 1 m

# Called when the node enters the scene tree for the first time.

func convert_pound_test():
	return pound_test * LBF_TO_N
	

func _ready():
	pass
#	verlet.ropeLength = 100.0
#	rod_verlet.ropeLength = 80.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
#	print(line_out)
	match observer_state:
		State.UNCASTABLE:
			pass
		State.CASTABLE:
			line_out = 0.5
		State.CASTING:
			pass
		State.IN_FLIGHT:
			reeling_time += 1
			if reeling_time > 5:
				spool_line_top = !spool_line_top
				reeling_time = 0
		State.DROPPED:
			print(bail)
			if bail:
				reeling_time += 1
				if reeling_time >10:
					spool_line_top = !spool_line_top
					reeling_time = 0
		State.REELING:
			reeling_time += 1
			if reeling_time > spool_switch_value/reeling_speed:
				spool_line_top = !spool_line_top
				reeling_time = 0
		State.IDLE:
			print(bail)
			if bail:
				reeling_time += 1
				if reeling_time >10:
					spool_line_top = !spool_line_top
					reeling_time = 0
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


func _on_PhysicsObserver_on_state_change(state):
	observer_state = state


func _on_Rod_on_rod_tip_move(rod_tip_position):
		rod_tip = rod_tip_position
		verlet.set_start(rod_tip_position)
		


func _on_BaitKinematic_on_move(target):
#		verlet.set_start(rod_tip)
		verlet.set_last(target.global_position)
		bait_velocity = target.velocity


func _on_Rod_on_reeling(spool_top_position, spool_bottom_position):
	if spool_line_top:
		rod_line.set_points([rod_tip, spool_top_position])
	else:
		rod_line.set_points([rod_tip, spool_bottom_position])


func _on_Reel_on_reeling(reel_speed, handle_rotation, tan_velocity, tan_acceleration):
	reeling_speed = reel_speed


func _on_Reel_on_bail_flipped(bail_open):
	pass # Replace with function body.
#	print(bail)
	bail = bail_open
