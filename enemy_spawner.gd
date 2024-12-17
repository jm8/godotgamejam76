extends Node2D

const EnemyScene = preload("res://enemy.tscn")

var time_between_enemies = 5
var time = 0
var time_til_next_enemy = 0
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
	time += 0.0
	time_til_next_enemy -= delta
	if time_til_next_enemy <= 0:
		spawn_enemy()
		time_til_next_enemy = time_between_enemies


func spawn_enemy():
	var enemy = EnemyScene.instantiate()
	enemy.curve = enemy_paths.pick_random()
	add_child(enemy)
