class_name SpellObject extends RigidBody3D
@export var spell_owner : Node3D
@export var spell : MagicSpellType
func calculate_damage(_entity:Entity)->float:
	return spell.damage
func on_hit(entity:Node3D):
	if (entity is Entity): entity.apply_damage(calculate_damage(entity))
	linear_velocity = Vector3.ZERO
	gravity_scale = 0
	get_tree().create_timer(0.5).timeout.connect(func():
		queue_free()
		var particle_child = (load("res://scenes/prefabs/death_particle.tscn") as PackedScene).instantiate() as UniParticles3D
		get_tree().root.add_child(particle_child)
		particle_child.global_position = global_position
		particle_child._emit_particle()
		get_tree().create_timer(particle_child.duration + 1).timeout.connect(func(): if (particle_child): particle_child.queue_free())
	)
	

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4
var lifetime : float = 0
func _physics_process(_delta: float) -> void:
	lifetime += _delta
	if (lifetime > 10 || global_position.y < -2000 || (spell.max_distance * spell.max_distance) < global_position.distance_squared_to(spell_owner.global_position)):
		get_parent().remove_child(self)
		self.queue_free()
	for node in get_colliding_bodies():
		if (node is player and spell_owner == node):
			continue
		on_hit(node)
			
