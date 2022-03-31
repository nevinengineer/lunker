extends Node2D

enum Action {EXTRA_FAST=15, FAST=25, MODERATE=30, SLOW=50, FULL=100}

enum State {UNCASTABLE, CASTABLE, CASTING, IN_FLIGHT, DROPPED, REELING, IDLE, STRIKING, SETTING, FIGHTING, LANDED, LOST}

export var rod_length : float #in meters
export var reel_seat_distance : float # in meters
export var diameter_butt : float # in inches
export var diameter_tip : float # in x, which is the numerator over 64 inch
export var tip_segments : int # more segments, smoother tip deformation
#export var rod_segments : int # the number of segments to break the rod into for deformation
export var point_load : int
export(Action) var action = Action.FAST

#var RodSpring = preload("res://Rod/Scenes/RodSpring.tscn")
var PositionSprite = preload("res://Rod/Scenes/PositionSprite.tscn")
#var ReelSprite = preload("res://Reel/Scenes/ReelSprite.tscn")

var rod_tip_position : Vector2
var bait : KinematicBody2D
var fight_force : int
#var rod_butt_position : Vector2

const M_TO_PX := 640 # 1 meter is 640 px
const IN_TO_M := 39.37 # 1 meter is 39.37 inches
const MIN_ANGLE = -120.0
const MAX_ANGLE := 45.0

var move_angle : float
var angular_velocity_initial := 0.0
var magnitude := 0.0
var time := 0.0
var magnitude_speed := 0.1

var observer_state : int

signal on_points_defined(points)
signal on_width_curve_defined(width_curve_params)
signal on_rod_move(target)
signal on_rod_tip_move(rod_tip_position)
signal on_catch_area_entered(rod_position)
signal on_deform(deform_points)
signal on_reeling(spool_top_position, spool_bottom_position)

func _define_points():
	var reel_seat_pixels = -reel_seat_distance * M_TO_PX
	var rod_length_pixels = rod_length * M_TO_PX
#	var segment_length = rod_length_pixels / rod_segments
	var tip_segment_length = ((action/100.0)/tip_segments) * rod_length_pixels
#	var points = [Vector2(0.0,0.0)]
	var points = [Vector2(reel_seat_pixels, 0)]
	var base_length = points[-1].x + ((100.0 - action)/100.0) * rod_length_pixels
#	var tip_segment_length = ((action/100.0)/tip_segments) * rod_length_pixels
#	var segment_length = ((action/100.0)/rod_segments) * rod_length_pixels
	points.append(Vector2(base_length, 0))
	var x_offset = points[-1].x
#	for i in range(0, rod_segments):
#		x_offset = points[-1].x + segment_length
#		points.append(Vector2(x_offset, 0.0))
#	return points
#	var points = [Vector2(reel_seat_pixels, 0)]
#	var base_length = points[-1].x + ((100.0 - action)/100.0) * rod_length_pixels
#	var tip_segment_length = ((action/100.0)/tip_segments) * rod_length_pixels
#
#	points.append(Vector2(base_length, 0))
#
#	var x_offset = points[-1].x
#
	for i in range(0, tip_segments):
		x_offset = points[-1].x + tip_segment_length
		points.append(Vector2(x_offset, 0))
		if i >=  2 and i % 2 == 0:
			var eyelet_line2d = Line2D.new()
			eyelet_line2d.set_default_color(Color.black)
			var eyelet_width = clamp(16/i, 8, 16)
			eyelet_line2d.set_width(eyelet_width)
			var eyelet_height = clamp(140/(i/2), 12, 80)
			eyelet_line2d.set_points([Vector2(x_offset, 0), Vector2(x_offset + 16, 16), Vector2(x_offset + 16, eyelet_height + 16/i)])
			add_child(eyelet_line2d)
			eyelet_line2d.set_name("EyeletLine2D_%s" %[i])
	
	var tip_eyelet_line2d = Line2D.new()
	tip_eyelet_line2d.set_default_color(Color.black)
	tip_eyelet_line2d.set_width(8)
	tip_eyelet_line2d.set_points([Vector2(points[-1].x + 128, 0), Vector2(points[-1].x + 140, 32)])
	add_child(tip_eyelet_line2d)
	tip_eyelet_line2d.set_name("EyeletLine2D_tip")
	var tip_eyelet_position2d = Position2D.new()
	tip_eyelet_position2d.global_position = tip_eyelet_line2d.get_points()[-1]
	add_child(tip_eyelet_position2d)
	tip_eyelet_position2d.set_name("TipEyeletPosition2D")

	return points

func _define_width_curve():
	var diameter_butt_meters = diameter_butt / IN_TO_M
	var diameter_tip_meters = (diameter_tip/64) / IN_TO_M
	
	var butt_width_pixels = diameter_butt_meters * M_TO_PX
	
	var tip_to_butt_ratio = diameter_tip_meters/diameter_butt_meters
	
	return {"width": butt_width_pixels, "min_value": tip_to_butt_ratio}


func _deform_points(deflection):
	var deformed_points_array = []
	var point_positions = get_tree().get_nodes_in_group("PointPositions")
	var extreme_positions = get_tree().get_nodes_in_group("ExtremePositions")
	var deformed_positions = get_tree().get_nodes_in_group("DeformedPositions")
#	var undeformed_points = point_positions.slice(1,3)
#	for point_position in point_positions.slice(1,2):
#		deformed_points_array.append(point_position.position)
#	deformed_points.append(Vector2.ZERO)
#	deformed_points.append(point_positions)
#	for i in range(4, deformed_positions.size()):
#	var deformed_points = deformed_positions.slice(4, deformed_positions.size())
	for point_position in point_positions:
		var p = point_positions.find(point_position)
#		var p = i - point_positions.size()
#		extreme_positions[i].position = extreme_positions[i].position + Vector2(-deflection/2, deflection * 2.0 * i)
#		var deformed_position = Position2D.new()
#		deformed_position.set_name("DeformPosition_%s" % [i])
#		deformed_position.add_to_group("DeformedPositions")
#		add_child(deformed_position)
#
#		var deformed_sprite = PositionSprite.instance()
#		deformed_sprite.set_color("yellow")
#		deformed_sprite.set_name("DeformedSprite_%s" % [i])
#		deformed_position.add_child(deformed_sprite)
		
#		var deformed_point = point_positions[i].global_position.linear_interpolate(extreme_positions[i].global_position, (0.10 * deflection) * ((0.5*i*sqrt((0.25*pow(i,2))) + 1) + pow(sinh(0.5*i), -1)))
#		var deformed_point = point_position.position.linear_interpolate(point_position.position + Vector2(-(deflection/4)*p, deflection/2 * p), 0.05 * ((0.5*p*sqrt((0.25*pow(p,2))) + 1) + pow(sinh(0.5*p), -1)))
#		var deformed_point = point_positions[i].position.linear_interpolate(point_positions[i].position + Vector2(-deflection/2, deflection * 2.0 * i), (0.10 * deflection) * (i/10))
#		deformed_point.x -= 16.0 * deflection
#		var deformed_point = point_positions[i].position + Vector2(0, 32 * i)
#		deformed_points_array.append(deformed_point)

		var deformed_point = point_position.position.linear_interpolate(point_position.position + Vector2(-(deflection/4)*p, deflection/2 * p), 0.05 * ((0.5*p*sqrt((0.25*pow(p,2))) + 1) + pow(sinh(0.5*p), -1)))
		
		
		deformed_points_array.append(deformed_point)
		
#	deformed_points[0] = Vector2.ZERO
	deformed_positions[-1].position = deformed_points_array[-1]
	var reel_sprites = get_tree().get_nodes_in_group("ReelSprite")
	if reel_sprites.size() == 1:
		reel_sprites[0].position = deformed_points_array[2] + Vector2(32, 64)
#	rod_tip_position = deformed_points_array[-1]
	emit_signal("on_deform", deformed_points_array)
	

#func _define_rod_springs(points):
#	var lengths = [20, 40, 80, 150, 200, 250]
#	for point in points:
#		var rod_spring = RodSpring.instance()
#		rod_spring.set_name("RodSpring%s" %[points.find(point)])
#		add_child(rod_spring)
#		rod_spring.position = point
#		var joint = rod_spring.get_node_or_null("Joint")
#		joint.set_length(lengths[points.find(point)])
#		print(joint.get_length())	

# Called when the node enters the scene tree for the first time.
func _ready():
	$CatchArea/CollisionShape2D.shape.set_radius(rod_length * M_TO_PX + 100)
#	$CatchArea/CollisionShape2D.shape.set_extents(Vector2(rod_length * M_TO_PX, rod_length * M_TO_PX))
#	var reel_sprite = ReelSprite.instance()
#	add_child(reel_sprite)
#	reel_sprite.position = Vector2(128, 64)
	var points = _define_points()
#	rod_tip_position = points[-1]
#	_define_rod_springs(points)
	emit_signal("on_points_defined", points)
	
	#define static points
	for point in points:
		
		#Undeformed Positions
		var point_position = Position2D.new()
		point_position.set_name("PointPosition_%s" %[points.find(point)])
		point_position.global_position = point
#		print(point_position.global_position)
		point_position.add_to_group("PointPositions")
		add_child(point_position)
#		rod_tip_position = point
		
#		var position_sprite = PositionSprite.instance()
#		position_sprite.set_color("white")
#		position_sprite.set_name("PositionSprite_%s"%[points.find(point)])
#		point_position.add_child(position_sprite)
		
		#Extreme Positions
#		var extreme_position = Position2D.new()
#		extreme_position.set_name("ExtremePosition_%s" %[points.find(point)])
#		extreme_position.global_position = point
##		print(point_position.global_position)
#		extreme_position.add_to_group("ExtremePositions")
#		add_child(extreme_position)
#
#		var extreme_sprite = PositionSprite.instance()
#		extreme_sprite.set_color("red")
#		extreme_sprite.set_name("InitialSprite_%s"%[points.find(point)])
#		extreme_position.add_child(extreme_sprite)
		
		#Deformed Positions
		var deformed_position = Position2D.new()
		deformed_position.set_name("DeformPosition_%s" % [points.find(point)])
		deformed_position.add_to_group("DeformedPositions")
		add_child(deformed_position)
		
#		var deformed_sprite = PositionSprite.instance()
#		deformed_sprite.set_color("yellow")
#		deformed_sprite.set_name("DeformedSprite_%s" % [points.find(point)])
#		deformed_position.add_child(deformed_sprite)
		

#			initial_position.position = initial_position.position + Vector2(0.0, 45.0)
	
	#define max deform points
	
	
	var width_curve_params = _define_width_curve()
	emit_signal("on_width_curve_defined", width_curve_params)
	
	_deform_points(magnitude)
	
#	var reel_seat_point = get_tree().get_nodes_in_group("PointPositions")[2]
#	var reel_seat_location = reel_seat_point.global_position
#	var reel_seat_rotation = rotation

	
#	var reel_seat_location = reel_seat_position[5].global_position
	
	
#	rod_tip_position = points[-1]
	
	
	
#	emit_signal("on_rod_tip_move", $RodLine2D/RodTipPosition.position)
	
#	rod_butt_position = points[0]
#	rod_tip_position = points[-1]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	time += delta
#	magnitude = sin(magnitude_speed * (2 * PI) * time)
#	pass
#	rotation_degrees += 0.5
#	print($RodLine2D.points[-1])

func _physics_process(delta):

#	var last_point = get_tree().get_nodes_in_group("PointPositions")[-1]
#	var last_point = deformed_points[-1]
#	if last_point:
	if $TipEyeletPosition2D != null:
		emit_signal("on_rod_tip_move", $TipEyeletPosition2D.global_position)
#		emit_signal("on_rod_tip_move", last_point)
#	print(magnitude)
	var reel_sprites = get_tree().get_nodes_in_group("ReelSprite")
	if reel_sprites.size() == 1:
		var spool_top_position = $ReelSprite/SpoolTop.global_position
		var spool_bottom_position = $ReelSprite/SpoolBottom.global_position
		emit_signal("on_reeling", spool_top_position, spool_bottom_position)
	var effective_radius = rod_length - reel_seat_distance
	var vector_from = polar2cartesian(effective_radius, deg2rad(rotation_degrees))
	
	rotation_degrees = lerp(rotation_degrees, move_angle, delta * 10)
	rotation_degrees = clamp(rotation_degrees, -160, 45)
	
	var vector_to = polar2cartesian(effective_radius, deg2rad(rotation_degrees))
	
	var delta_angle = vector_from.angle_to(vector_to)
	
	var angular_velocity = delta_angle/(delta*10)
	
	var tan_velocity = angular_velocity * effective_radius
	
	var delta_angular_velocity = angular_velocity - angular_velocity_initial
	
	var avg_angular_acceleration = delta_angular_velocity / (delta * 10)
	
	var avg_tangential_acceleration = effective_radius * avg_angular_acceleration
	
#	print("angular velocity: %f, angular acceleration: %f, tangential acceleration: %f" \
#	% [angular_velocity, avg_angular_acceleration, avg_tangential_acceleration])
	
	match observer_state:
		State.UNCASTABLE:
			pass
		State.CASTABLE:
			_deform_points(0)
		State.CASTING:
			pass
		State.IN_FLIGHT:
			magnitude = 0
			_deform_points(magnitude * sin(get_angle_to(bait.global_position)))
		State.DROPPED:
			pass
		State.REELING:
			magnitude = 0
			_deform_points(magnitude * sin(get_angle_to(bait.global_position)))
			if $ReelSprite:
				var spool_top_position = $ReelSprite/SpoolTop.global_position
				var spool_bottom_position = $ReelSprite/SpoolBottom.global_position
				emit_signal("on_reeling", spool_top_position, spool_bottom_position)
#				print($ReelSprite/SpoolTop.global_position)
#				print($ReelSprite/SpoolBottom.global_position)
		State.IDLE:
			magnitude = 0
			_deform_points(magnitude * sin(get_angle_to(bait.global_position)))
		State.STRIKING:
			magnitude = 0
			_deform_points(magnitude * sin(get_angle_to(bait.global_position)))
		State.SETTING:
			magnitude = 0
			_deform_points(magnitude)
		State.FIGHTING:
#			print(fight_force * sin(get_angle_to(bait.global_position)))
			fight_force = 0
			_deform_points(fight_force * sin(get_angle_to(bait.global_position)))
		State.LANDED:
			pass
		State.LOST:
			pass
	
	
	
#	rotation = lerp(rotation, move_angle, delta * 20);
	


func _on_RodController_on_mouse_move(event):
	pass
#	move_position = $RodLine2D/RodTipPosition.position.angle_to_point(event.position)
#	move_position = get_global_mouse_position() * -1 # invert the y-direction to match angle sign
#	move_position = get_viewport().get_mouse_position() * -1
#	emit_signal("on_rod_tip_move", $RodLine2D/RodTipPosition.global_position)
#	print(move_position.y)
#	move_angle = (atan2(vector_towards_target.y, vector_towards_target.x))
#	move_angle = $RodLine2D/RodTipPosition.global_position.angle_to_point(event.global_position + Vector2(500,500))
#	print(move_angle)
#	rotation = lerp(rotation, angle, delta * 20);
	


func _on_PhysicsObserver_on_state_change(state):
	observer_state = state


func _on_MouseController_on_new_angle(angle):
	move_angle = angle
	emit_signal("on_rod_move", self)
#	print(angle)
#	print(angle)
#	emit_signal("on_rod_tip_move", $RodLine2D/RodTipPosition.position)


func _on_CatchArea_body_entered(body):
	if(body.is_in_group("bait") and observer_state == State.REELING or observer_state == State.IDLE or observer_state == State.FIGHTING or observer_state == State.DROPPED):
#		print(position)
		emit_signal("on_catch_area_entered", position)


#func _on_FishingController_on_load(direction):
#	if direction == "increase":
#		magnitude = 100
#	if direction == "decrease":
#		magnitude = 50
#	magnitude = clamp(magnitude, 0.0, 100.00)
#	print(magnitude)
#	_deform_points(magnitude * sin(get_angle_to(bait.global_position)))


func _on_BaitKinematic_on_move(target):
	bait = target


func _on_TestFish_on_fight(force):
	fight_force = force


func _on_Reel_on_reel_ready(reel_sprite):
	var reel = reel_sprite.instance()
	add_child(reel)
	reel.set_name("ReelSprite")
	reel.add_to_group("ReelSprite")
	var reel_seat_point = get_tree().get_nodes_in_group("PointPositions")[2]
	var reel_seat_location = reel_seat_point.position
	reel.position = reel_seat_location + Vector2(32, 64)
	var spool_top_position = $ReelSprite/SpoolTop.global_position
	var spool_bottom_position = $ReelSprite/SpoolBottom.global_position
	emit_signal("on_reeling", spool_top_position, spool_bottom_position)
	
	


func _on_Reel_on_reeling(reel_speed, handle_rotation, tan_velocity, tan_acceleration):
	if $ReelSprite != null:
		$ReelSprite/HandleSprite.rotation = handle_rotation


func _on_CameraController_on_rod_camera():
	$Camera2D.current = true
