extends Node2D
class_name Enemy

@export var curve: Curve2D

var t = 0
# var offset = 40 * sqrt(randf()) * Vector2.from_angle(randf_range(0, TAU))
var offset = Vector2(0, 0)

@export var enemy_name = "basic enemy"
@export var speed = 200
@export var base_health = 10
@export var qc_damage = 1

var health: float

func _ready() -> void:
	global_position = curve.sample(0, 0)

func _process(delta: float) -> void:
	t += delta
	var baked = curve.sample_baked_with_rotation(speed * t)
	global_position = baked.get_origin() + offset

	$Health.text = str(round(health))
	
	if health <= 0:
		queue_free()
