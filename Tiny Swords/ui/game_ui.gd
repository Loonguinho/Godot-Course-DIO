extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel
@onready var exp_bar: ProgressBar = %ExpBar
@onready var level: Label = %Level

func _process(delta: float):
	meat_label.text = str(GameManager.meat_counter)
	#Set time
	timer_label.text = GameManager.time_elapsed_string
	level.text = str(GameManager.level)
	exp_bar.max_value = int(GameManager.experience_required)
	exp_bar.value = int(GameManager.experience)
