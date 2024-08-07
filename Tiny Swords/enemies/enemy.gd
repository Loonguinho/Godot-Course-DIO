class_name Enemy
extends Node2D
@export_category("Life")
@export var health: float = 10

@export_category("Death")
@export var death_prefab: PackedScene

@export_category("Damage")
@export var enemy_damage: float = 1.0

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

@export_category("Damage Marker")
@onready var damage_digit_marker = $DamageMarker
var damage_digit_prefab: PackedScene

@export_category("Enemy Exp")
@export var exp_amount = 10

func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func take_damage(amount: float) -> void:
	health -= amount
	
	#Hit damage
	modulate = Color.RED
	var tween = create_tween().tween_property(self, "modulate", Color.WHITE, 0.3)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	
	#Create Damage digit
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = round(amount)
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	
	get_parent().add_child(damage_digit)
	
	if health <= 0:
		die()


func die() -> void:
	#Skull
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	#Drop
	if randf() <= drop_chance:
		drop_item()
	
	GameManager.monster_defeated += 1
	GameManager.gain_experience(exp_amount)
	
	#Delete node
	queue_free()
	
func drop_item():
	var drop = get_random_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)

func get_random_item() -> PackedScene:
	#Return first and only item if list size is 1
	if drop_items.size() == 1:
		return drop_items[0]
	
	#Calculate max chance
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	
	#Random number
	var random_value = randf() * max_chance
	
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
		
	return drop_items[0]


