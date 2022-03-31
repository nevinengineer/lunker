extends Line2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var deformation_dictionary
#var rod_tip : Position2D
#var PositionSprite = preload("res://Rod/Scenes/PositionSprite.tscn")
#var rod_tip : Vector2
#export var deformation_resource : Resource

#var RodSpring = preload("res://Rod/Scenes/RodSpring.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	rod_tip = Position2D.new()
#	if deformation_resource:
#		deformation_dictionary = deformation_resource._init()
#		print(deformation_dictionary)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print(points)

#func deform(point_load):
#	var new_points = [] 
#	var deformation_array = (deformation_dictionary[point_load])
#	var point_positions = get_tree().get_nodes_in_group("PointPositions")
#	for i in range(0, point_positions.size()):
#		var point_position = point_positions[i]
#		var deformation_vector = (deformation_array[i])
#		var new_point = Vector2(point_position.global_position.x * deformation_vector.x, point_position.global_position.y * deformation_vector.y)
#
#		new_points.append(new_point)
#
##	rod_tip.global_position = new_points[-1]
#	return(new_points)
		
		
		


func _on_Rod_on_points_defined(points):
#	print(points)
	set_points(points)
#	for point in points:
#		pass
#		var point_position = Position2D.new()
#		point_position.set_name("PointPosition_%s" %[points.find(point)])
#		point_position.global_position = point
##		print(point_position.global_position)
#		point_position.add_to_group("PointPositions")
#		add_child(point_position)
#		rod_tip = point
#
#		var position_sprite = PositionSprite.instance()
#		point_position.add_child(position_sprite)
#		position_sprite.set_name("PositionSprite_%s"%[points.find(point)])
#		position_sprite.global_position = point
	
	
	
#	print(get_children())
#		var static_point = StaticBody2D.new()
#		static_point.set_name("StaticPoint%s" %[points.find(point)])
#		var kinematic_point = KinematicBody2D.new()
#		kinematic_point.set_name("KinematicPoint%s" %[points.find(point)])
#		kinematic_point.add_to_group("KinematicPoints")
#		var spring_joint = DampedSpringJoint2D.new()
#		spring_joint.set_name("SpringJoint%s" % [points.find(point)])
#
#		var collision_shape = CollisionShape2D.new()
#		var collider_circle = CircleShape2D.new()
#
#		collider_circle.set_radius(10.0)
#
#		collision_shape.set_shape(collider_circle)
#
#		add_child(static_point)
#		add_child(kinematic_point)
#		add_child(spring_joint)
#
#		kinematic_point.add_child(collision_shape)
#
#		spring_joint.node_a = get_node(static_point.name).get_path()
#		spring_joint.node_b = get_node(kinematic_point.name).get_path()
#
#		spring_joint.set_length(10.0)
#
#		static_point.position = point
#		kinematic_point.position = point
		
		
		
#	$RodTipPosition.position = points[-1]

func _physics_process(delta):
	pass
#	var new_points = deform(8)
#	set_points(new_points)
#	$RodTipPosition2D.position = new_points[-1]
#	rod_tip = $RodTipPosition2D.global_position
	
func _on_Rod_on_width_curve_defined(width_curve_params):
	set_width(width_curve_params.width)
	width_curve.set_min_value(width_curve_params.min_value)


func _on_Rod_on_rod_move(target):
	pass
#	print(target)
#	var new_points = deform(2)
##	print("deformed points %s" % points.size())
#	set_points(new_points)
#	rod_tip = new_points[-1]
#	print("Rod Tip Point %s" %[rod_tip])
#	$RodTipPosition2D.position = new_points[-1]
	
#	print("RodTipPosition position %s "%[$RodTipPosition2D.global_position])
#	$RodTipPosition2D.position = points[-1]
#	rod_tip = $RodTipPosition2D.global_position
#	print(rod_tip.global_position)
##	var rod_tip = get_tree().get_nodes_in_group("RodTip")
#	print(rod_tip)
#	var rod_spring_list = get_tree().get_nodes_in_group("RodSprings")
#	print(rod_spring_list)


func _on_Rod_on_deform(deform_points):
	set_points(deform_points)
