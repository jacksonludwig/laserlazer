class_name Laser
extends Line2D
## Laser wall

## this status should be inherited from the vertex and not be modified manually
@export var status: Enums.StatusType = Enums.StatusType.INACTIVE

## the collision and laser will extend to this point when active
@onready var end_point := Vector2(self.points[1].x, self.points[1].y)
@onready var start_point := Vector2(self.points[0].x, self.points[0].y)

@onready var collision_shape: CollisionShape2D = $Area2D.get_child(0)
@onready var parent_vertex: Vertex = get_parent()

## tween used for animating state changes
var _tween: Tween


func _ready():
	# ignore any extra points added in editor
	self.points = self.points.slice(0, 2)

	# set the laser's width to be relative to the vertex's size
	self.width = parent_vertex.collision_shape_size.x - 2

	# set the laser to zero size if the default state is inactive
	if status == Enums.StatusType.INACTIVE:
		_update_laser_ending_point(start_point)

	parent_vertex.connect("status_change", _on_active_status_changed)


func _on_active_status_changed(new_status: Enums.StatusType, status_change_speed: float):
	status = new_status

	match new_status:
		Enums.StatusType.ACTIVE:
			_on_become_active(status_change_speed)
		Enums.StatusType.INACTIVE:
			_on_become_inactive(status_change_speed)


## tween the collision and laser to maximum size
func _on_become_active(change_speed: float):
	## if needed, re-active collision immediately
	if collision_shape.disabled:
		collision_shape.disabled = false

	_get_tween().tween_method(_update_laser_ending_point, self.points[1], end_point, change_speed)


## tween the collision and laser to minimum size
func _on_become_inactive(change_speed: float):
	_get_tween().tween_method(_update_laser_ending_point, self.points[1], start_point, change_speed)


## update the collision and visual line of the laser to end at the given point
func _update_laser_ending_point(new_end_point: Vector2):
	self.points[1] = new_end_point
	collision_shape.position = new_end_point / 2
	collision_shape.shape.size = Vector2(new_end_point[0], self.width)


func _on_tween_finished():
	## if the status is inactive and the tween just finished, disable collision
	if status == Enums.StatusType.INACTIVE:
		collision_shape.disabled = true


func _get_tween():
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.connect("finished", _on_tween_finished)
	return _tween
