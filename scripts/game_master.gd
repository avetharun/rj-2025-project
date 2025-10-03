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
