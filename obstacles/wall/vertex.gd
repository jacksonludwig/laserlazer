class_name Vertex
extends Node2D
## Node controlling the positioning and movement of one or more edges.

enum StatusType {
	INACTIVE,
	ACTIVE
}

## Modifiers with lower values will take precedence in some cases
## (e.g. if frozen and sped up, it will remain just frozen)
enum MovementModifier {
	NONE = 0,
	FROZEN = 1,
	REVERSED = 2,
	FAST = 4,
}

## emitted when the wall state changes (e.g. the wall becomes ACTIVE)
signal status_change(new_status: StatusType)

@export_category("Movement Options")
@export_flags("Frozen", "Reverse", "Rotate", "Fast") var movement_state_modifier: int = 0
@export var speed_modifer: int = 1
@export var speed: int = 1
@export_category("")

@export_category("Status Options")
@export var state: StatusType = StatusType.INACTIVE
@export_category("")


func _ready():
	pass


func _process(_delta):
	## movement is controlled through the defined path
	if get_parent().get_class() == "WallFollowPath":
		pass
	
	## movement controlled through code
	pass


## get the vertex's speed after modifiers have been applied
func _get_modified_speed():
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.FROZEN):
		pass
	
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.FAST):
		pass
		
	if Utils.check_bit_flag(movement_state_modifier, MovementModifier.REVERSED):
		pass
