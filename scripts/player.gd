class_name player extends Entity
@export var CameraRaycast : Area3D
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("action_pause")):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
	pass
func _physics_process(_delta):
	super._physics_process(_delta);
	var phys_move = Input.is_action_just_pressed("action_phys_move");
	var phys_interact = Input.is_action_just_pressed("action_interact");
	var bodies = CameraRaycast.get_overlapping_bodies().filter(func(body):return body is BaseCollisionBody);
	if (CameraRaycast.has_overlapping_bodies() && ( phys_move or phys_interact )):
		if (len(bodies) > 0):
			if (phys_move):
				bodies[0].on_phys_move();
			else:
				bodies[0].on_pick();
			pass
	pass
func _input(event):
	super._input(event)
	pass
