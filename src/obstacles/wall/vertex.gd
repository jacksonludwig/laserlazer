class_name Vertex
extends Node2D
## Node controlling the positioning and movement of one or more edges.

## Modifiers with lower values will take precedence in some cases
## (e.g. if frozen and sped up, it will remain just frozen)
enum MovementModifier { NONE = 0, FROZEN = 1, REVERSED = 2, ROTATE = 4, FAST = 8, SLOW = 16 }

## emitted when the wall state changes (e.g. the wall becomes ACTIVE)
signal status_change(new_status: Enums.StatusType, status_change_speed: float)

@export_category("Movement Options")
@export_flags("Frozen", "Reverse", "Rotate", "Fast", "Slow") var movement_state_modifier: int = 0
@export var speed: float = 50
@export var rotate_speed: float = 50
@export var fast_speed_multiplier: float = 2
@export_category("")

@export_category("Status Options")
## how many seconds it takes for the lasers to grow/shrink to the new status
@export var status_change_speed: float = 3
@export var status: Enums.StatusType = Enums.StatusType.INACTIVE:
	set(new_status):
		status = new_status
		status_change.emit(new_status, get_modified_speed().status_change)
@export_category("")

@onready var parent_node: Node = get_parent()
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

## length and size to set the vertex's collision to
@export var collision_shape_size = Vector2(8, 8)

# TODO: add visual for vertex


func _ready():
	self.collision_shape.shape.size = collision_shape_size

	## emit the initial state so all edges are in sync
	status_change.emit(status, status_change_speed)


func _physics_process(delta):
	rotate(deg_to_rad(get_modified_speed().rotation * delta))

	## movement is controlled through the defined path
	if parent_node is WallPathFollow:
		pass

	## movement controlled through code
	pass


## get the vertex's speed after modifiers have been applied
func get_modified_speed() -> CurrentSpeedData:
	var speed_data := CurrentSpeedData.new(speed, rotate_speed, status_change_speed)

	_apply_rotate(speed_data)
	_apply_fast(speed_data)
	_apply_slow(speed_data)
	_apply_reverse(speed_data)
	_apply_frozen(speed_data)

	return speed_data


func _apply_frozen(data: CurrentSpeedData) -> CurrentSpeedData:
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.FROZEN):
		data.movement = 0
		data.rotation = 0

	return data


func _apply_rotate(data: CurrentSpeedData) -> CurrentSpeedData:
	if !Utils.check_bit_flag(movement_state_modifier, MovementModifier.ROTATE):
		data.rotation = 0

	return data


func _apply_fast(data: CurrentSpeedData) -> CurrentSpeedData:
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.FAST):
		data.movement = data.movement * fast_speed_multiplier
		data.rotation = data.rotation * fast_speed_multiplier
		data.status_change = data.status_change / fast_speed_multiplier

	return data


func _apply_slow(data: CurrentSpeedData) -> CurrentSpeedData:
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.SLOW):
		data.movement = data.movement / fast_speed_multiplier
		data.rotation = data.rotation / fast_speed_multiplier
		data.status_change = data.status_change * fast_speed_multiplier

	return data


func _apply_reverse(data: CurrentSpeedData) -> CurrentSpeedData:
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.REVERSED):
		data.movement = data.movement * -1
		data.rotation = data.rotation * -1

	return data


## class for holding speed data about a vertex, e.g. movement speed
class CurrentSpeedData:
	var movement: float
	var rotation: float
	var status_change: float

	func _init(_movement, _rotation, _status_change):
		self.movement = _movement
		self.rotation = _rotation
		self.status_change = _status_change
