class_name WallFollowPath
extends PathFollow2D
## Attach vertices to this path in order to have the wall follow the set path.


func _process(delta):
	set_progress(get_progress() + get_child(0).get_modified_speed() * delta)
