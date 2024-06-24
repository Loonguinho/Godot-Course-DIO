extends Node

@export var object_templates: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	
func _input(event: InputEvent) -> void:
	#Check if event is a left click
	if event is InputEventMouseButton:
		if event.button_index == 2:
			if event.pressed:
				print(event)
				spawn_object(event.position)


func spawn_object(position: Vector2) -> void:
	var index: int = randi_range(0,object_templates.size() - 1)
	var object_template = object_templates[index]
	var object: RigidBody2D = object_template.instantiate()
	object.position = position
	add_child(object)
