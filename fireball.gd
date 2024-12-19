extends Sprite2D
class_name Fireball

var time = 0.25

func _physics_process(delta: float) -> void:
	position += Vector2(2500, 0).rotated(global_rotation) * delta
	time -= delta
	if time < 0:
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		for e in $BlastRadius.get_overlapping_areas():
			if e.get_parent() is Enemy:
				e.get_parent().health -= 20
		visible = false
		queue_free()
