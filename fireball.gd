extends Sprite2D
class_name Fireball

var time = 0.25
var damage = 20
var pierce = false
var speed = 2500

func _physics_process(delta: float) -> void:
	position += Vector2(speed, 0).rotated(global_rotation) * delta
	time -= delta
	if time < 0:
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		if not pierce:
			for e in $BlastRadius.get_overlapping_areas():
				if e.get_parent() is Enemy:
					e.get_parent().damage(damage)
			visible = false
			queue_free()
		else:
			area.get_parent().damage(damage)
