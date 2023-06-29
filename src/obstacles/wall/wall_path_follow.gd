class_name WallPathFollow
extends PathFollow2D
## Attach vertices to this path in order to have the wall follow the set path.

@onready var vertex: Vertex = get_child(0)


func _physics_process(delta):
	assert(vertex is Vertex, "Wall path expected child to be a vertex")
	set_progress(get_progress() + vertex.get_modified_speed().movement * delta)
