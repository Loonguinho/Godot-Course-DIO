extends Node2D

@export var regeneration_amount: int = 10

func _ready():
	$Area2D.body_entered.connect(on_body_entred)
	

func on_body_entred(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		print("Vida atual ",player.health)
		player.heal(regeneration_amount)
		print("Vida atual ",player.health)
		queue_free()
