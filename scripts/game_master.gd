extends Node

var timer = Timer.new()
var GameTime : float
var PhysGameTime : float
func _process(delta):
	GameTime += delta;
func _physics_process(delta: float) -> void:
	PhysGameTime += delta;
func _ready():
	print("globalAutoload Ready")
	
	add_child(timer)
	timer.start(3)
	
func align_with_y(xform : Transform3D, new_y : Vector3):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
