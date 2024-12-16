extends Node2D
class_name Enemy

@export var curve: Curve2D

var t = 0
var offset = 40 * sqrt(randf()) * Vector2.from_angle(randf_range(0, TAU))

var speed = 250

var health = 10

func _process(delta: float) -> void:
	t += delta
	var baked = curve.sample_baked_with_rotation(speed * t)
	global_position = baked.get_origin() + offset
	
	if health <= 0:
		queue_free()
