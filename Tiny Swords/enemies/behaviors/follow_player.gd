extends Node
 

@export var speed: float = 1.0


var enemy: Enemy
var sprite: AnimatedSprite2D

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

	
func _physics_process(delta: float) -> void:
	#Calculate enemy direction
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	#Movement
	enemy.velocity = input_vector * speed * 100.0
	enemy.move_and_slide()
	
	#Flip enemy sprite
	flip_sprite(input_vector)


func flip_sprite(input_vector) -> void:
	#Flip sprite
	if input_vector.x > 0:
		#turn off flip H
		sprite.flip_h = false
	elif input_vector.x < 0:
		#turn on flip H
		sprite.flip_h = true
