extends CharacterBody2D

@export var speed = 3.0
@export_range(0, 1) var lerp_factor = 0.5

@onready var sprite = %ShipGreenManned

func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_velocity = direction * speed * 100.0
	#lerp
	velocity = lerp(velocity, target_velocity, lerp_factor)

	var target_location = direction.x * 25.0
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_location, lerp_factor)
	
	print(lerp(6.0, 16.0, 0.2))
	move_and_slide()
