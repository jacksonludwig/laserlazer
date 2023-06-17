class_name Vertex
extends Node2D
## Node controlling the positioning and movement of one or more edges.

## Modifiers with lower values will take precedence in some cases
## (e.g. if frozen and sped up, it will remain just frozen)
enum MovementModifier {
	NONE = 0,
	FROZEN = 1,
	REVERSED = 2,
	FAST = 4,
}

## emitted when the wall state changes (e.g. the wall becomes ACTIVE)
signal status_change(new_status: Enums.StatusType)

@export_category("Movement Options")
@export_flags("Frozen", "Reverse", "Rotate", "Fast") var movement_state_modifier: int = 0
@export var fast_speed_multiplier: float = 2
@export var speed: float = 1
@export_category("")

@export_category("Status Options")
@export var state: Enums.StatusType = Enums.StatusType.INACTIVE:
	set(new_status):
		status_change.emit(new_status)
		state = new_status
@export_category("")


func _process(_delta):
	## movement is controlled through the defined path
	if get_parent() is WallFollowPath:
		pass

	## movement controlled through code
	pass


## get the vertex's speed after modifiers have been applied
func get_modified_speed() -> float:
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.FROZEN):
		return 0

	var modified_speed := speed

	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.FAST):
		modified_speed = modified_speed * fast_speed_multiplier

	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.REVERSED):
		modified_speed = modified_speed * -1

	return modified_speed
