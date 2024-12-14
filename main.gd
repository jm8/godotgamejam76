extends Node2D

func _ready() -> void:
	print(Globulars.test)

func _process(_delta: float) -> void:
	var mouse = $TileMapLayer.get_local_mouse_position()
	var moose = $TileMapLayer.local_to_map(mouse)
	$SelectedHexagon.global_position = $TileMapLayer.global_position + $TileMapLayer.map_to_local(moose)
