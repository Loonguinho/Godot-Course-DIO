extends Node2D

@export var exp_amount: int = 10

func _ready():
	$Area2D.body_entered.connect(on_body_entred)
	

func on_body_entred(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		#GameManager.gain_experience(exp_amount)
		print("Pegou xp: ", exp_amount )
		queue_free()
