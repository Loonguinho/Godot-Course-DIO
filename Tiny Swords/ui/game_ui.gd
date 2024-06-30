extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel

func _process(delta: float):
	meat_label.text = str(GameManager.meat_counter)
	#Set time
	timer_label.text = GameManager.time_elapsed_string

