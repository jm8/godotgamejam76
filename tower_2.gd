extends Tower

@onready var fireball_scene = preload("res://fireball.tscn")


var cooldown_time: float = 2
var cooldown_timer: float = cooldown_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if temperature < min_temperature:
		delete()
		return

	$TemperatureBar.value = temperature
	$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_LOW)
	if temperature > operating_temperature:
		$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_MEDIUM)
	if temperature > min_temperature + (max_temperature - min_temperature) * 0.8:
		$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_HIGH)
		
	var target: Enemy = get_tree().get_first_node_in_group("targets" + name)
	cooldown_timer = max(0, cooldown_timer - delta)
	if cooldown_timer <= 0 and target:
		var fireball: Fireball = fireball_scene.instantiate()
		var rotation: float = global_position.direction_to(target.global_position).angle()
		fireball.global_rotation = rotation
		add_child(fireball)
		print("FIRE!")
		cooldown_timer = cooldown_time
	

func _on_range_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().add_to_group("targets" + name)


func _on_range_area_exited(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().remove_from_group("targets" + name)
