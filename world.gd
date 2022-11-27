extends Node2D

const board_size = 600
const num_icebergs = 30
const safe_zone_size = 256

@onready var player = get_node("ship")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var ice_scenes = [
		preload("res://ice/ice_1.tscn"),
		preload("res://ice/ice_2.tscn"),
		preload("res://ice/ice_3.tscn"),
		preload("res://ice/ice_4.tscn"),
		preload("res://ice/ice_5.tscn"),
		preload("res://ice/ice_6.tscn")
	]
	for i in range(0,num_icebergs):
		var ice_idx = randi_range(0,ice_scenes.size()-1)
		var ice = ice_scenes[ice_idx].instantiate()
		var spawn_size = board_size*1.2
		var pos = Vector2(randf_range(-spawn_size, spawn_size), randf_range(-spawn_size, spawn_size))
		while (pos - Vector2.ZERO).length() < safe_zone_size:
			pos = Vector2(randf_range(-spawn_size, spawn_size), randf_range(-spawn_size, spawn_size))
		ice.position = pos
		ice.rotation = randf_range(0,360)
		add_child(ice)
		
	player.health_depleted.connect(_on_update_health)
	player.died.connect(_on_died)

func _on_update_health():
	print_debug(player.health)

func _on_died():
	print_debug(player.health)
	
func _win():
	get_tree().change_scene_to_file("res://win_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if absf(player.position.x) > board_size or absf(player.position.y) > board_size:
		_win()
