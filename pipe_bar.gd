extends Node2D

var pipe: Pipe
var previous_temperature: float

func _ready() -> void:
	previous_temperature = pipe.temperature
	$TemperatureBar.value = pipe.temperature
	$TemperatureBar.min_value = pipe.min_temperature
	$TemperatureBar.max_value = pipe.max_temperature
	add_to_group(Globulars.PIPE_GROUP)
	set_bar_style(temperature_range(pipe.temperature))

func _process(delta: float) -> void:
	$Label.text = str(round(pipe.temperature * 100) / 100.)
	$TemperatureBar.value = pipe.temperature

	var previous_range = temperature_range(previous_temperature)
	var next_range = temperature_range(pipe.temperature)
	if previous_range != next_range:
		set_bar_style(next_range)

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

func temperature_range(temperature: float) -> TemperatureRange:
	var range = TemperatureRange.Low
	if temperature > pipe.min_temperature + (pipe.max_temperature - pipe.min_temperature) * 0.2:
		range = TemperatureRange.Medium
	if temperature > pipe.min_temperature + (pipe.max_temperature - pipe.min_temperature) * 0.8:
		range = TemperatureRange.High
	return range

func display() -> void:
	self.modulate.a = 1


func undisplay() -> void:
	self.modulate.a = 0
