class_name GameOverUi
extends CanvasLayer

@onready var time_label: Label = %TimeCount
@onready var monster_label: Label = %MonsterCount


@export var restart_delay: float = 20.0
var restart_cooldown: float



func _ready():
	time_label.text = GameManager.time_elapsed_string
	monster_label.text = str(GameManager.monster_defeated)
	restart_cooldown = restart_delay
	
	
func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()
		
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
