class_name Edge
extends Area2D
## Static edge that expects to be a child of a vertex

@export var status: Enums.StatusType = Enums.StatusType.INACTIVE


func _ready():
	assert(get_parent() is Vertex, "expected parent of edge to always be vertex")
	get_parent().connect("status_change", _on_active_status_changed)


func _on_active_status_changed(new_status: Enums.StatusType):
	status = new_status
