extends Node2D
class_name Tower

@export var tower_type: TowerType

@export var tower_tile_position: Vector2i

var temperature: float = 260:
	set(value): temperature = set_temperature(value)
var specific_heat: float = 2

const min_temperature: float = 220
const operating_temperature: float = 261
const max_temperature: float = 400

func set_temperature(value):
	return value

func _ready() -> void:
	add_to_group(Globulars.TOWER_GROUP)

func _physics_process(delta: float):
	var pipe = Globulars.pipes.get(tower_tile_position)
	if pipe:
		Globulars.average_temperature_tower(pipe, self, delta)
	temperature -= 0.02 * delta * (temperature - 220)

func _process(delta: float) -> void:
	pass

func delete():
	Globulars.towers_by_position.erase(tower_tile_position)
	queue_free()
