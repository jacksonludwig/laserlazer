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
		status_change.emit(new_status, get_modified_speed()[2])
@export_category("")

@onready var parent_node: Node = get_parent()

# TODO: add collision shape and visual for vertex, and attach lasers to edges


func _ready():
	## emit the initial state so all edges are in sync
	status_change.emit(status, status_change_speed)


func _process(delta):
	var speeds := get_modified_speed()
	rotate(deg_to_rad(speeds[1] * delta))

	## movement is controlled through the defined path
	if parent_node is WallPathFollow:
		pass

	## movement controlled through code
	pass


## get the vertex's speed after modifiers have been applied
## returns tuple of [movement speed, rotation speed, status change speed]
func get_modified_speed() -> Array[float]:
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.FROZEN):
		return [0, 0]

	var modified_speed := speed
	var modified_rotate := rotate_speed
	var modified_change := status_change_speed

	if !Utils.check_bit_flag(movement_state_modifier, MovementModifier.ROTATE):
		modified_rotate = 0

	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.FAST):
		modified_speed = modified_speed * fast_speed_multiplier
		modified_rotate = modified_rotate * fast_speed_multiplier
		modified_change = modified_change / fast_speed_multiplier

	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.SLOW):
		modified_speed = modified_speed / fast_speed_multiplier
		modified_rotate = modified_rotate / fast_speed_multiplier
		modified_change = modified_change * fast_speed_multiplier

	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.REVERSED):
		modified_speed = modified_speed * -1
		modified_rotate = modified_rotate * -1

	return [modified_speed, modified_rotate, modified_change]
