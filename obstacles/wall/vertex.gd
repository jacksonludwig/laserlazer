class_name Vertex
extends Node2D
## Node controlling the positioning and movement of one or more edges.

enum StatusType {
	INACTIVE,
	ACTIVE
}

enum MovementModifier {
	NONE = 0,
	FROZEN = 1,
	REVERSED = 2,
}

## emitted when the wall state changes (e.g. the wall becomes ACTIVE)
signal status_change(new_status: StatusType)

@export_category("Movement Options")
@export_flags("Frozen", "Reverse", "Rotate") var movement_state_modifier = 0
@export var speed_modifer = 1
@export var speed = 1
@export_category("")

@export_category("Status Options")
@export var state: StatusType = StatusType.INACTIVE
@export_category("")


func _ready():
	pass


func _process(_delta):
	pass
