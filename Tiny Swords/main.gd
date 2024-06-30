extends Node

@export var game_ui: CanvasLayer
@export var game_over_ui: PackedScene

func _ready():
	GameManager.on_game_over.connect(trigger_game_over)

func trigger_game_over():
	#Delete Game UI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	#Create Game Over Ui
	var game_over_ui: GameOverUi = game_over_ui.instantiate()
	add_child(game_over_ui)
