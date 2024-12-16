extends Tower

const fire_time: float = 0.5
const cooldown_time: float = 1

var fire_timer: float = 0
var cooldown_timer: float = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Laser.add_point($LaserSource.position)
	$Laser.add_point(Vector2(0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("targets " + name + ": ", get_tree().get_nodes_in_group("targets" + name))
	var target: Enemy = get_tree().get_first_node_in_group("targets" + name)
	if fire_timer > 0:
		if target:
			if len($Laser.points) == 2:
				$Laser.visible = true
				$Laser.points[1] = to_local(target.global_position)
				self.temperature -= 15 * delta
				target.health -= 10 * delta
		else:
			$Laser.visible = false
			fire_timer = 0
		fire_timer = max(0, fire_timer - delta)
		if(fire_timer <= 0):
			cooldown_timer = cooldown_time
	else:
		$Laser.visible = false
		cooldown_timer = max(0,cooldown_timer - delta)
		if cooldown_timer <= 0 and target:
			fire_timer = fire_time
	$TemperatureBar.value = temperature
	
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().add_to_group("targets" + name)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().remove_from_group("targets" + name)
