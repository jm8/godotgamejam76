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
	$TemperatureBar.min_value = min_temperature
	$TemperatureBar.max_value = max_temperature
	set_bar_style(temperature_range(temperature))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if temperature < min_temperature:
		delete()
		return
		
	$TemperatureBar.value = temperature

	if temperature < operating_temperature:
		return
	temperature -= 12 * delta
	
	var targets = $Area2D.get_overlapping_areas()
	for target in targets.map(func(x): return x.get_parent()):
		if target is Enemy:
			# cannot be evaded
			target.health -= 4 * delta
