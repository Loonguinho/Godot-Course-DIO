class_name Enemy
extends Node2D

@export var health: float = 10
@export var death_prefab: PackedScene
@export var enemy_damage: float = 1.0

func damage(amount: float) -> void:
	health -= amount
	print("Dano:"+str(amount) + "Life:" + str(health))
	
	#Hit damage
	modulate = Color.RED
	var tween = create_tween().tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	
	if health <= 0:
		die()


func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
	
	queue_free()
		
