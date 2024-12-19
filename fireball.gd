extends Sprite2D
class_name Fireball

var time = 10

func _process(delta: float) -> void:
	position += Vector2(20, 0).rotated(global_rotation)
	time -= delta
	if time < 0:
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		print("HIT")
		for e in $BlastRadius.get_overlapping_areas():
			print(e)
			if e.get_parent() is Enemy:
				e.get_parent().health -= 20
		visible = false
		queue_free()
