extends Node

var timer = Timer.new()

func _ready():
	print("globalAutoload Ready")
	
	add_child(timer)
	timer.start(3)
