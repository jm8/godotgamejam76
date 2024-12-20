extends Tower

const fire_time: float = 0.5
const cooldown_time: float = 1

var fire_timer: float = 0
var cooldown_timer: float = 1

func set_temperature(value):
	var previous_range = temperature_range(temperature)
	var next_range = temperature_range(value)
	if previous_range != next_range:
		set_bar_style(next_range)
	return value

enum TemperatureRange {
	Low,
	Medium,
	High
}

func set_bar_style(range: TemperatureRange):
	match range:
		TemperatureRange.Low:
			$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_LOW)
		TemperatureRange.Medium:
			$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_MEDIUM)
		TemperatureRange.High:
			$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_HIGH)

func temperature_range(t: float) -> TemperatureRange:
	var range = TemperatureRange.Low
	if t > operating_temperature:
		range = TemperatureRange.Medium
	if t > min_temperature + (max_temperature - min_temperature) * 0.8:
		range = TemperatureRange.High
	return range

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Laser.add_point($LaserSource.position)
	$Laser.add_point(Vector2(0, 0))
	$TemperatureBar.min_value = min_temperature
	$TemperatureBar.max_value = max_temperature
	set_bar_style(temperature_range(temperature))
	upgrades.append(TowerUpgrade.new("Better Focusing", "Improves tower range", 100))
	upgrades.append(TowerUpgrade.new("Blue Lasers", "Improves tower damage", 100))
	upgrades.append(TowerUpgrade.new("Purple Lasers", "Combines red and blue lasers for maximum damage", 100))

func handle_upgrade(index: int):
	print("upgrade index: ", index)
	if index == 0:
		$Area2D/CollisionShape2D.shape.radius = 800
	if index == 1 and not upgrades[2].purchased:
		$Laser.default_color = Color(0, 0, 1)
	if index == 2:
		$Laser.default_color = Color(1, 0, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if temperature < min_temperature:
		delete()
		return
		
	$TemperatureBar.value = temperature

	if temperature < operating_temperature:
		$Laser.visible = false
		return

	#print("targets " + name + ": ", get_tree().get_nodes_in_group("targets" + name))
	var target: Enemy = get_tree().get_first_node_in_group("targets" + name)
	if fire_timer > 0:
		if target:
			if len($Laser.points) == 2:
				$Laser.visible = true
				$Laser.points[1] = to_local(target.global_position)
				self.temperature -= 15 * delta
				var damage = 10
				if upgrades[1].purchased:
					damage += 10
				if upgrades[2].purchased:
					damage += 30
				
				target.health -= damage * delta
		else:
			$Laser.visible = false
			fire_timer = 0
		fire_timer = max(0, fire_timer - delta)
		if (fire_timer <= 0):
			cooldown_timer = cooldown_time
	else:
		$Laser.visible = false
		cooldown_timer = max(0, cooldown_timer - delta)
		if cooldown_timer <= 0 and target:
			fire_timer = fire_time


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().add_to_group("targets" + name)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().remove_from_group("targets" + name)
