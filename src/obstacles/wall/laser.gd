class_name Laser
extends ShapeCast2D
## Laser wall

## this status should be inherited from the vertex and not be modified manually
@export var status: Enums.StatusType = Enums.StatusType.INACTIVE

## the collision and laser will extend to these values when the edge is active.
@onready var end_point := Vector2(self.target_position.x, self.target_position.y)
@onready var laser_width: float = self.shape.size[1]

@onready var vertex: Vertex = get_parent()

## number of seconds it takes to animate between statuses
var active_status_change_duration: float = 3

## tween used for animating state changes
var _tween: Tween


func _ready():
	# set the laser to zero size if the default state is inactive
	if status == Enums.StatusType.INACTIVE:
		_update_laser_ending_point(Vector2.ZERO)

	vertex.connect("status_change", _on_active_status_changed)


func _on_active_status_changed(new_status: Enums.StatusType):
	status = new_status

	match new_status:
		Enums.StatusType.ACTIVE:
			_on_become_active()
		Enums.StatusType.INACTIVE:
			_on_become_inactive()


## tween the collision and laser to maximum size
func _on_become_active():
	_get_tween().tween_method(
		_update_laser_ending_point, self.target_position, end_point, active_status_change_duration
	)


## tween the collision and laser to minimum size
func _on_become_inactive():
	_get_tween().tween_method(
		_update_laser_ending_point, self.target_position, Vector2.ZERO, active_status_change_duration
	)


## update the collision and visual line of the laser to end at the given point
func _update_laser_ending_point(end_point: Vector2):
	self.target_position = end_point
	$LaserVisual.points[1] = end_point


func _get_tween():
	if _tween:
		return _tween
	return create_tween()
