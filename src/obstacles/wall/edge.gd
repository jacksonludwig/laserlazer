class_name Edge
extends Area2D
## Static edge that expects to be a child of a vertex

## this status should be inherited from the vertex and not be modified manually
@export var status: Enums.StatusType = Enums.StatusType.INACTIVE

@onready var vertex: Vertex = get_parent()
@onready var laser: Laser = $LaserShape
@onready var laserLine: Line2D = laser.get_child(0)

## the collision and lazer will extend to these values when the edge is active
var max_collision_size: Vector2

## number of seconds it takes to animate between statuses
var active_status_change_duration: float = 0.5


func _ready():
	assert(laser is Laser)
	assert(
		laser.shape is SegmentShape2D,
		"expected edge's collision shape to have a segment bounding box"
	)
	assert(vertex is Vertex, "expected parent of edge to always be vertex")

	# save the maximum dimensions of the collision shape
	max_collision_size = laser.shape.b

	# set the laser to zero size if the default state is inactive
	if status == Enums.StatusType.INACTIVE:
		_update_laser_size(Vector2.ZERO)

	vertex.connect("status_change", func(new_status):
		status = new_status
		_on_active_status_changed(new_status))
	

func _on_active_status_changed(new_status: Enums.StatusType):
	match new_status:
		Enums.StatusType.ACTIVE:
			_on_become_active()
		Enums.StatusType.INACTIVE:
			_on_become_inactive()


## tween the collision and laser to maximum size
func _on_become_active():
	_get_tween().tween_method(_update_laser_size, laser.shape.b, max_collision_size, active_status_change_duration)


## tween the collision and laster to minimum size
func _on_become_inactive():
	_get_tween().tween_method(_update_laser_size, laser.shape.b, Vector2.ZERO, active_status_change_duration)


func _update_laser_size(size: Vector2):
	laser.shape.b = size
	laserLine.points[1] = size


var _tween: Tween
func _get_tween():
	if _tween: return _tween
	return create_tween()
