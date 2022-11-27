extends Node2D

const board_size = 6000
const num_icebergs = 3000
const safe_zone_size = 256

@onready var player = get_node("ship")
@onready var health_bar = get_node("ship/health_bar")
@onready var new_game = get_node("new_game")
@onready var game_end_text = get_node("new_game/win_text")

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
	health_bar.value = player.health

func _on_died():
	game_end_text.text = "[center]The ship has taken too much damage![/center]"
	new_game.visible = true
	
func _win():
	game_end_text.text = "[center]Congrats! You've escaped![/center]"
	new_game.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	new_game.position = player.position
	if absf(player.position.x) > board_size or absf(player.position.y) > board_size:
		_win()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
