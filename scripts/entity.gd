@tool extends UCharacterBody3D
class_name Entity

var max_health = 100
var current_health = 100
var mana_sickness = 0
var health_regen = 0.1
var armor = 0

var max_mana = 25
var current_mana = 25
var mana_regen = 0.1

func regen_health():
	if (current_health < max_health):
		if((health_regen+current_health) >max_health):
			current_health = max_health
		else: current_health += health_regen

func regen_mana():
	if (current_mana < max_mana):
		if((mana_regen+current_mana)> max_mana):
			current_mana = max_mana
		else: current_mana += mana_regen

func apply_damage(amount):
	if(armor >0): amount = amount *((100-armor)*.01)
	if(current_health > amount): current_health-= amount
	else: print("death")

func _on_global_timer_timeout():
	print("Gloabl Timeout In Entity.gd")

func _ready():
	GameMaster.timer.timeout.connect(_on_global_timer_timeout())


func _physics_process(delta):
	if((GameMaster.timer.count %20) == 0):
		regen_health()
		regen_mana()
