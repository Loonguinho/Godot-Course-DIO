extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel
@onready var gold_label: Label = %GoldLabel

var time_elapsed: float = 0.0

func _process(delta: float):
	#Update timer
	time_elapsed += delta
	var time_elapsed_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_seconds % 60
	var minutes: int = time_elapsed_seconds / 60
	
	#Set time
	timer_label.text = "%02d:%02d" % [minutes, seconds]
