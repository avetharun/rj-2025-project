@warning_ignore("missing_tool")
extends CharacterBody3D
class_name Entity

@export var max_health : float = 100
@export var current_health : float = 100
@export var mana_sickness : float = 0
@export var health_regen : float = 0.1
@export var armor : float = 0

@export var max_mana : float = 25
@export var current_mana : float = 25
@export var mana_regen : float = 0.1
var current_regen_timeout : float = 0
@export var regen_timeout_seconds : float = 0.1
@export var mesh : MeshInstance3D
var damage_time : float
@export var invulnerable : bool = false
@export var death_particle_origin : Node3D
func _ready():
	mesh = get_children().filter(func(c): return c is MeshInstance3D)[0] if mesh == null else mesh
	current_regen_timeout = regen_timeout_seconds;
	print(mesh)
	rebake_material_emissions()
	pass
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
func on_death():
	invulnerable = true
	print("dieded")
	var tween := create_tween()
	tween.tween_method(
		(func(_xrot): self.rotation.x = _xrot),
		rotation.x, rotation.x + (deg_to_rad(90)), 0.35
	)
	get_tree().create_timer(0.5).timeout.connect(func():
		queue_free()
		var particle_child = (load("res://scenes/prefabs/death_particle.tscn") as PackedScene).instantiate() as UniParticles3D
		get_tree().root.add_child(particle_child)
		particle_child._emit_particle()
		particle_child.global_position = global_position if death_particle_origin == null else death_particle_origin.global_position
		get_tree().create_timer(particle_child.duration).timeout.connect(func(): particle_child.queue_free())
	)
	pass
func apply_damage(amount):
	if (invulnerable): return
	damage_time = 0.5
	if(armor >0): amount = amount *((100-armor)*.01)
	if(current_health > amount): current_health-= amount
	else: on_death()
var base_mat_emissions : Array[Color] = []
var mat_emission_targets : Array[Color] = []

func rebake_material_emissions():
	base_mat_emissions.clear()
	for i in range(0, mesh.get_surface_override_material_count()):
		var mat = mesh.get_active_material(i)
		if (mat is StandardMaterial3D):
			base_mat_emissions.append(mat.emission)
		else:
			base_mat_emissions.append(mat.get_shader_parameter("emission") as Color)
	pass

func attacked(amount):
	apply_damage(amount)
	pass
func on_melee(amount):
	attacked(amount)
	pass
func on_interact():
	pass

func _physics_process(_delta):
	if (damage_time < 0):
		for i in range(0, mesh.get_surface_override_material_count()):
			var mat = mesh.get_active_material(i)
			var c = base_mat_emissions[i]
			if (mat is StandardMaterial3D):
				mat.emission = c
			else: 
				mat.set_shader_parameter("emission", c)
	if (damage_time > 0):
		for i in range(0, mesh.get_surface_override_material_count()):
			var c = Color.RED
			var mat = mesh.get_active_material(i)
			if (mat is StandardMaterial3D):
				mat.emission = c
			else: 
				mat.set_shader_parameter("emission", c)
	damage_time -= _delta
	current_regen_timeout-=_delta
	if(current_regen_timeout <= 0):
		current_regen_timeout = regen_timeout_seconds
		regen_health()
		regen_mana()
