extends Node2D

@onready var ui = $UI
@onready var tile_map = $TileMapLayer
@onready var tower_being_placed = $TowerBeingPlaced
@onready var pipe_tile_map = $PipeTileMap

var hover_tile_posision = null

const PipeScene = preload("res://pipe.tscn")
const PIPE_TILE_SOURCE_ID = 4
const HOVER_PIPE_TILE_SOURCE_ID = 1

enum ActionState {
	TowerPlacing,
	PipePlacing,
}

var action_state: ActionState = ActionState.TowerPlacing

func _process(_delta: float) -> void:
	var mouse_tile_pos = position_to_tile(get_global_mouse_position())
	if ui.placing_tower_type != null:
		if not tower_being_placed.visible or position_to_tile(tower_being_placed.global_position) != mouse_tile_pos:
			tower_being_placed.modulate = Color(0, 1, 0, 0.2) if can_place_tower(mouse_tile_pos) else Color(1, 0, 0, 0.2)
		tower_being_placed.visible = true
		tower_being_placed.global_position = tile_to_position(mouse_tile_pos)
		tower_being_placed.texture = ui.placing_tower_type.texture
	else:
		tower_being_placed.visible = false

	if Input.is_key_pressed(KEY_E):
		action_state = ActionState.PipePlacing
		get_tree().call_group(Globulars.PIPE_GROUP, "display")
	else:
		get_tree().call_group(Globulars.PIPE_GROUP, "undisplay")
		action_state = ActionState.TowerPlacing

	if action_state == ActionState.TowerPlacing:
		pipe_tile_map.modulate.a = 0.5
		pipe_tile_map.z_index = 0
	if action_state == ActionState.PipePlacing:
		pipe_tile_map.modulate.a = 1
		pipe_tile_map.z_index = 1

	var tile_position = position_to_tile(get_global_mouse_position())
	if hover_tile_posision != null and pipe_tile_map.get_cell_source_id(hover_tile_posision) == HOVER_PIPE_TILE_SOURCE_ID:
		pipe_tile_map.erase_cell(hover_tile_posision)
		hover_tile_posision = null
	if action_state == ActionState.PipePlacing:
		if !has_pipe(tile_position):
			pipe_tile_map.set_cell(tile_position, HOVER_PIPE_TILE_SOURCE_ID, Vector2i.ZERO)
			hover_tile_posision = tile_position
		
		var pipe_cost = pow(Globulars.PIPE_COST_BASE, (abs(tile_position[0]) + abs(tile_position[1]))/ Globulars.PIPE_COST_COEFFICIENT) + 10	
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !has_pipe(tile_position) and pipe_cost <= Globulars.crypto:
			Globulars.crypto -= pipe_cost
			Globulars.play_coins_sound()
			add_child(DispersingText.create(get_global_mouse_position(), ("-%s crypto" % str(pipe_cost)), Color.RED))
			pipe_tile_map.set_cells_terrain_connect([tile_position], 0, 0)
			var pipe = Pipe.new()
			Globulars.pipes[tile_position] = pipe
			var pipe_scene = PipeScene.instantiate()
			pipe_scene.pipe = pipe
			pipe_scene.global_position = tile_to_position(tile_position)
			add_child(pipe_scene)

		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and has_pipe(tile_position):
			var amount = int(pipe_cost* 0.7)
			Globulars.crypto += amount
			Globulars.play_get_coins_sound()
			add_child(DispersingText.create(get_global_mouse_position(), "+" + str(amount) + " crypto", Color.GREEN))
			remove_pipe(tile_position)

func remove_pipe(tile_position: Vector2i) -> void:
	pipe_tile_map.erase_cell(tile_position)
	var pipe = Globulars.pipes[tile_position]
	Globulars.pipes.erase(tile_position)
	var neighbors = get_neighboring_cells(pipe_tile_map, tile_position).filter(func(neighbor):
		return pipe_tile_map.get_cell_source_id(neighbor) == PIPE_TILE_SOURCE_ID)
	for neighbor in neighbors:
		pipe_tile_map.set_cell(neighbor, PIPE_TILE_SOURCE_ID, Vector2i.ZERO)
	for pipe_scene in get_tree().get_nodes_in_group(Globulars.PIPE_GROUP):
		if pipe_scene.pipe == pipe:
			remove_child(pipe_scene)
	pipe_tile_map.set_cells_terrain_connect(neighbors, 0, 0)

func _physics_process(delta: float) -> void:
	update_pipes(pipe_tile_map, delta)

func get_neighboring_cells(map: TileMapLayer, pos: Vector2i) -> Array[Vector2i]:
	return [
		map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE),
		map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE),
		map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE),
		map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE),
		map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE),
		map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_SIDE),
	]

func position_to_tile(pos: Vector2) -> Vector2i:
	var mouse_pos = tile_map.get_global_transform().inverse() * pos
	var mouse_tile = tile_map.local_to_map(mouse_pos)
	return mouse_tile

func tile_to_position(tile: Vector2i) -> Vector2:
	return tile_map.get_global_transform() * tile_map.map_to_local(tile)

func _unhandled_input(event: InputEvent) -> void:
	var tile_position = position_to_tile(get_global_mouse_position())
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		handle_left_click(tile_position)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		handle_right_click(tile_position)

func handle_left_click(pos: Vector2i):
	if action_state == ActionState.TowerPlacing and ui.placing_tower_type != null and can_place_tower(pos) and ui.placing_tower_type.cost <= Globulars.crypto:
		Globulars.crypto -= ui.placing_tower_type.cost
		Globulars.play_coins_sound()
		add_child(DispersingText.create(get_global_mouse_position(), "-" + str(ui.placing_tower_type.cost) + " crypto", Color.RED))
		var tower = create_tower(pos, ui.placing_tower_type)
		add_child(tower)
	elif action_state == ActionState.TowerPlacing and ui.placing_tower_type == null:
		var tower = Globulars.towers_by_position.get(pos)
		if tower != null:
			ui.open_tower_panel(tower)

func handle_right_click(_pos: Vector2i):
	pass

func can_place_tower(pos: Vector2i) -> bool:
	if pos == Vector2i(0, 0):
		# quantum computer
		return false
	if Globulars.towers_by_position.has(pos):
		# on top of tower
		return false
	if $TileMapLayer.get_cell_atlas_coords(pos).y in [4, 5, 6]:
		# y coordinates on texture atlas for paths
		return false
	return true

func has_pipe(tile_position: Vector2i) -> bool:
	return pipe_tile_map.get_cell_source_id(tile_position) == PIPE_TILE_SOURCE_ID

func create_tower(pos: Vector2i, tower_type: TowerType) -> Tower:
	var tower = tower_type.scene.instantiate()
	tower.tower_type = tower_type
	tower.tower_tile_position = Vector2i(pos)
	tower.global_position = tile_to_position(pos)
	Globulars.towers_by_position[pos] = tower
	return tower

var amortization: int = 4
var amortization_counter: int = 0

func update_pipes(map: TileMapLayer, delta: float):
	# updates are order dependent, probably not a real issue
	var adelta = delta * amortization
	for i in range(0, len(Globulars.pipes), amortization):
		if i + amortization_counter >= len(Globulars.pipes):
			break
		var pos = Globulars.pipes.keys()[i + amortization_counter]
		var neighbors = [
			map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE),
			map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE),
			map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE),
		]if randf() > 0.5  else [
			map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_SIDE),
			map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_SIDE),
			map.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_SIDE),
		]
		neighbors = neighbors.filter(func(neighbor): return pipe_tile_map.get_cell_source_id(neighbor) == PIPE_TILE_SOURCE_ID)
		for neighbor in neighbors:
			Globulars.average_temperature(pos, neighbor, adelta)
		var pipe = Globulars.pipes[pos]
		pipe.temperature -= 2 * adelta
		if pipe.temperature < pipe.min_temperature:
			remove_pipe(pos)
	
	amortization_counter = (amortization_counter + 1) % amortization
