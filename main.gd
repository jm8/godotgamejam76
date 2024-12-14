extends Node2D

@onready var ui = $UI
@onready var tile_map = $TileMapLayer
@onready var tower_being_placed = $TowerBeingPlaced

func _process(_delta: float) -> void:
	if ui.selected_tower != null:
		tower_being_placed.visible = true
		tower_being_placed.global_position = tile_to_position(position_to_tile(get_global_mouse_position()))
		tower_being_placed.texture = ui.selected_tower.texture
	else:
		tower_being_placed.visible = false

func position_to_tile(pos: Vector2) -> Vector2:
	var mouse_pos = tile_map.get_global_transform().inverse() * pos
	var mouse_tile = tile_map.local_to_map(mouse_pos)
	return mouse_tile

func tile_to_position(tile: Vector2) -> Vector2:
	return tile_map.get_global_transform() * tile_map.map_to_local(tile)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_click(get_global_mouse_position())

func handle_click(pos: Vector2):
	var tower = create_tower(ui.selected_tower)
	ui.selected_tower = null
	tower.global_position = tile_to_position(position_to_tile(pos))
	add_child(tower)


func create_tower(tower_type: TowerType):
	var tower = Sprite2D.new()
	tower.texture = tower_type.texture
	return tower
