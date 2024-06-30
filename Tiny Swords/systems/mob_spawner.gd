class_name MobSpawner
extends Node2D

@export var creatures: Array[PackedScene]
var mobs_per_minute: float  = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var cooldown: float = 0.0


func _process(delta):
	if GameManager.is_game_over: return
	
	#Cooldown
	cooldown -= delta
	if cooldown > 0: return
	
	#Monster frequency
	var interval = 60.0 / mobs_per_minute
	cooldown = interval
	
	#Check if spawn is valid
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parametres = PhysicsPointQueryParameters2D.new()
	parametres.position = point
	parametres.collision_mask = 0b1000
	var results: Array = world_state.intersect_point(parametres, 1)
	if not results.is_empty(): return
	

	#Instantiate random monster
	var index = randi_range(0, creatures.size() -1)
	var creatures_scene = creatures[index]
	var creature = creatures_scene.instantiate()
	creature.global_position = get_point()
	get_parent().add_child(creature)
	
	
func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
