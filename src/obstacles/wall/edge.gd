class_name Edge
extends Area2D
## Static edge that expects to be a child of a vertex

## this status should be inherited from the vertex and not be modified manually
@export var status: Enums.StatusType = Enums.StatusType.INACTIVE:
	set(new_status):
		if status == new_status:
			return
		status = new_status
		_on_active_status_changed(new_status)

@onready var vertex: Vertex = get_parent()
@onready var collision_shape: CollisionShape2D = get_child(0)

## the collision and lazer will extend to these values when the edge is active
var max_collision_width: float
var max_collision_length: float


func _ready():
	assert(collision_shape is CollisionShape2D)
	assert(
		collision_shape.shape is RectangleShape2D,
		"expected edge's collision shape to have a rectangular bounding box"
	)
	assert(vertex is Vertex, "expected parent of edge to always be vertex")

	# save the maximum dimensions of the collision shape
	max_collision_length = collision_shape.shape.size.x
	max_collision_width = collision_shape.shape.size.y

	# set the collision box to zero size if the default state is inactive
	if status == Enums.StatusType.INACTIVE:
		collision_shape.shape.size = Vector2.ZERO

	vertex.connect("status_change", func(new_status): status = new_status)


func _on_active_status_changed(new_status: Enums.StatusType):
	match new_status:
		Enums.StatusType.ACTIVE:
			_on_become_active()
		Enums.StatusType.INACTIVE:
			_on_become_inactive()


## tween the collision and laser to maximum size
func _on_become_active():
	pass


## tween the collision and laster to minimum size
func _on_become_inactive():
	pass
