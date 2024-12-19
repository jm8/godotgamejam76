extends Node2D

const EnemyScene = preload("res://enemy.tscn")
const EnemySlowScene = preload("res://enemy_slow.tscn")

# parameters
var wave_duration = 30
var time_between_waves = 30
var time_between_enemies = 5

var is_in_wave = false

# if not in wave
var time_til_next_wave = 30

# if in wave
var time_til_next_enemy = 0
var time_til_wave_ends = 0

var time = 0
var wave_num = 0

var enemy_paths = [
	create_path([Vector2i(30, -15), Vector2i(0, 0)]),
	create_path([Vector2i(30, 15), Vector2i(0, 0)]),
	create_path([Vector2i(-30, -15), Vector2i(0, 0)]),
	create_path([Vector2i(-30, 15), Vector2i(0, 0)]),
	create_path([Vector2i(0, 30), Vector2i(0, 0)]),
	create_path([Vector2i(0, -30), Vector2i(0, 0)]),
]

func create_path(points: Array[Vector2i]) -> Curve2D:
	var curve = Curve2D.new()
	for point in points:
		curve.add_point(Vector2(point.x * 64, (point.y + .5 * (point.x % 2)) * 111))
	return curve

func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	time += delta
	if is_in_wave:
		time_til_wave_ends -= delta
		time_til_next_enemy -= delta
		if time_til_wave_ends <= 0:
			is_in_wave = false
			time_til_next_wave = time_between_waves
		elif time_til_next_enemy <= 0:
			spawn_enemy()
			time_til_next_enemy = time_between_enemies
	else:
		time_til_next_wave -= delta
		if time_til_next_wave <= 0:
			wave_num += 1
			is_in_wave = true
			time_between_enemies = 5 / (1.5 * wave_num)
			wave_duration = 25 + 5 * wave_num
			time_til_wave_ends = wave_duration
			time_til_next_enemy = time_between_enemies
			

func spawn_enemy():
	var enemy: Enemy
	if randi_range(0, 1) == 1:
		enemy = EnemyScene.instantiate()
	else:
		enemy = EnemySlowScene.instantiate()
	enemy.curve = enemy_paths.pick_random()
	add_child(enemy)
