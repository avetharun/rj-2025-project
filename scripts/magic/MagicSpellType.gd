class_name MagicSpellType extends Resource
@export var spell_name : String
@export var cooldown : float
@export var spell_prefab : PackedScene
@export var initial_velocity : float
@export var damage : float
@export var max_distance : float = 32
func cast(owner: Node3D, tree: SceneTree, from:Vector3, dir:Vector3, velocity:float = 1):
	var particle_child = spell_prefab.instantiate() as SpellObject
	particle_child.position = from
	tree.root.add_child(particle_child)
	particle_child.linear_velocity = dir * velocity * initial_velocity
	particle_child.look_at(from + dir)
	#particle_child.transform = GameMaster.align_with_y(particle_child.transform, dir.normalized())
	particle_child.spell_owner = owner
	particle_child.spell = self
	pass
