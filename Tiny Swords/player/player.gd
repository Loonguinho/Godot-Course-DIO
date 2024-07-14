class_name Player
extends CharacterBody2D
@export_category("Movement")
@export var speed: float = 3.0

@export_category("Damage")
@export var sword_damage: float = 1.5

@export_category("Spell")
@export var spell_damage: float = 5
@export var spell_interval: float = 10
@export var spell_scene: PackedScene

@export_category("Life")
@export var health: float = 100.0
@export var max_health: float = 100.0
@export var death_prefab: PackedScene

@export_category("Level System")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitBoxArea
@onready var health_bar: ProgressBar = $HealthBar

var input_vector:Vector2 = Vector2(0, 0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var spell_cooldown: float = 0.0
var experience: int = 0
var experience_total: int = 0
var level: int = GameManager.level
var experience_required = GameManager.get_required_exp(level + 1)


signal meat_collected(value: int)

func _ready():
	GameManager.player = self
	meat_collected.connect(func (value: int): GameManager.meat_counter += 1)

func _process(delta: float) -> void:
	#Get Playpos to GamaManager
	GameManager.player_position = position
	read_input()
	#Update Attack Cooldown
	update_attack_cooldown(delta)
	#Attack
	if Input.is_action_just_pressed("attack"):
		attack()	
	#Play idle and run animations
	play_animation_run_idle()
	#Flip sprite
	if not is_attacking:
		flip_sprite()
	
	#Process Damage
	update_damage_detection(delta)
	
	#Spell
	update_spell(delta)
	
	#Update health bar
	update_health_bar()

func _physics_process(delta: float) -> void:
	#Modify velocity
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.00
	velocity = lerp(velocity, target_velocity, 0.1)
	move_and_slide()

func read_input() -> void:
	#Get input vector
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	
	#Update is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func flip_sprite() -> void:
	#Flip sprite
	if input_vector.x > 0:
		#turn off flip H
		sprite.flip_h = false
	elif input_vector.x < 0:
		#turn on flip H
		sprite.flip_h = true

func play_animation_run_idle() -> void:
	#Play animation
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func attack() -> void:
	
	# Check if it is in cooldown
	if is_attacking:
		return
	
	# Play attack animation
	animation_player.play("attack_side_1")
	
	# Set cooldown
	attack_cooldown = 0.6

	# Player is attacking
	is_attacking = true

func update_attack_cooldown(delta: float) -> void:
	#Update Attack cooldown
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func deal_damage_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if  dot_product >= 0.3:
				enemy.damage(sword_damage)
				
		pass

func update_damage_detection(delta):
	#Temporizer
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	#Frequency
	hitbox_cooldown = 0.5
	#HitBoxArea Find enemy in area
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount: float = enemy.enemy_damage
			damage(damage_amount)

func damage(amount: float) -> void:
	if health <=0: return
	
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
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	return health

func update_spell(delta: float):
	spell_cooldown -= delta
	if spell_cooldown > 0: return
	spell_cooldown = spell_interval
	
	#create spell
	var spell = spell_scene.instantiate()
	spell.damage_amount = spell_damage
	add_child(spell)	

func update_health_bar() -> void:
	health_bar.max_value = max_health
	health_bar.value = health

