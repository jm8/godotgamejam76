extends Tower

@onready var fireball_scene = preload("res://fireball.tscn")


var cooldown_time: float = 2
var cooldown_timer: float = cooldown_time

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

func _ready() -> void:
	$TemperatureBar.min_value = min_temperature
	$TemperatureBar.max_value = max_temperature
	set_bar_style(temperature_range(temperature))
	upgrades.append(TowerUpgrade.new("Hotter Fireballs", "makes the fireballs hotter, increasing damage", 100))
	upgrades.append(TowerUpgrade.new("Tritium", "greatly increases the size of fireball explosions", 100))
	upgrades.append(TowerUpgrade.new("Negative Temperature", "negative temperature fireballs are actually hotter than infite temperature, massively increasing damage", 100))
	upgrades.append(TowerUpgrade.new("Plasma Blaster", "fireballs no longer explode on impact, but pierce infinitely", 100))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if temperature < min_temperature:
		delete()
		return
	
	$TemperatureBar.value = temperature
	
	if temperature < operating_temperature:
		return
	
	var target: Enemy = get_tree().get_first_node_in_group("targets" + name)
	
	temperature -= 20 * (cooldown_timer - max(0, cooldown_timer - delta))
	cooldown_timer = max(0, cooldown_timer - delta)
	if cooldown_timer <= 0 and target:
		temperature -= 10
		var fireball: Fireball = fireball_scene.instantiate()
		var rotation: float = global_position.direction_to(target.global_position).angle()
		fireball.global_rotation = rotation
		
		if upgrades[0].purchased:
			fireball.damage += 20
		if upgrades[1].purchased:
			if upgrades[3].purchased:
				fireball.scale *= 1.5
			else:
				fireball.get_node("BlastRadius/CollisionShape2D").shape.radius = 1500
		if upgrades[2].purchased:
			fireball.damage += 60
		if upgrades[3].purchased:
			fireball.pierce = true
			fireball.scale *= 1.5
			fireball.speed += 1500
		add_child(fireball)
		cooldown_timer = cooldown_time
	

func _on_range_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().add_to_group("targets" + name)


func _on_range_area_exited(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		area.get_parent().remove_from_group("targets" + name)
