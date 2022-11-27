extends Node2D

const board_size = 6000
const num_icebergs = 3000
const safe_zone_size = 256

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
		var pos = Vector2(randf_range(-board_size, board_size), randf_range(-board_size, board_size))
		while (pos - Vector2.ZERO).length() < safe_zone_size:
			pos = Vector2(randf_range(-board_size, board_size), randf_range(-board_size, board_size))
		ice.position = pos
		ice.rotation = randf_range(0,360)
		add_child(ice)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
