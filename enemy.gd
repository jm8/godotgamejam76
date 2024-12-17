extends Node2D
class_name Enemy

@export var curve: Curve2D

var t = 0
# var offset = 40 * sqrt(randf()) * Vector2.from_angle(randf_range(0, TAU))
var offset = Vector2(0, 0)

var speed = 200

var health = 10

var qc_damage = 1

func _ready() -> void:
	global_position = curve.sample(0, 0)

func _process(delta: float) -> void:
	t += delta
	var baked = curve.sample_baked_with_rotation(speed * t)
	global_position = baked.get_origin() + offset
	
	if health <= 0:
		queue_free()
