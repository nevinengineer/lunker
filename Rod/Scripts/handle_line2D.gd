extends Line2D

const cork = Color( 0.94, 0.92, 0.72, 1 )

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Rod_on_points_defined(points):
	points[-1] -= Vector2(-128, 0)
	set_points(points.slice(1,2))
	
	var top_handle_line = Line2D.new()
	add_child(top_handle_line)
	top_handle_line.set_name("TopHandleLine2D")
	top_handle_line.set_width(20)
	top_handle_line.set_default_color(cork)
	top_handle_line.set_begin_cap_mode(1)
	top_handle_line.set_end_cap_mode(1)
	top_handle_line.set_points([Vector2(points[3].x - 128, 0), Vector2(points[3].x -64, 0)])


func _on_Rod_on_deform(deform_points):
#	deform_points[-1] -= Vector2(-128, 0)
	set_points(deform_points.slice(0,2))
	var top_handle_points_begin = Vector2(deform_points[3].x - 128, deform_points[3].y)
	var top_handle_points_end = Vector2(deform_points[3].x - 64, deform_points[3].y)
	$TopHandleLine2D.set_points([top_handle_points_begin, top_handle_points_end])
