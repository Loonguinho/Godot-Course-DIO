extends Node

signal on_game_over

var player: Player
var player_position: Vector2
var is_game_over: bool = false

var time_elapsed: float = 0.0
var time_elapsed_string: String
var meat_counter: int = 0
var time_survived: String
var monster_defeated: int
var experience: int = 0
var experience_total: int = 0
var level: int = 1
var experience_required = get_required_exp(level + 1)

func end_game():
	if is_game_over: return
	is_game_over = true
	on_game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	time_elapsed = 0.0
	time_elapsed_string = ""
	meat_counter = 0
	time_survived = ""
	monster_defeated = 0
	level = 1
	experience = 0
	experience_required = 0
	experience_total = 0
	
	for connection in on_game_over.get_connections():
		on_game_over.disconnect(connection.callable)

func _process(delta: float):
	#Update timer
	time_elapsed += delta
	var time_elapsed_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_seconds % 60
	var minutes: int = time_elapsed_seconds / 60
	
	#Set time
	time_elapsed_string = "%02d:%02d" % [minutes, seconds]


func get_required_exp(level: int) -> int:
	return round(pow(level, 2) + level * 4 + 8)

func gain_experience(amount: int) -> void:
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()

func level_up() -> void:
	level += 1
	experience_required = get_required_exp(level + 1)
	player.sword_damage +=  player.sword_damage*0.09
	player.spell_damage += player.spell_damage*0.09
	player.max_health += player.max_health*0.02
	#player.spell_interval -= 0.01 
