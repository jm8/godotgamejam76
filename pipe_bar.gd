extends Node2D

var pipe: Pipe

func _ready() -> void:
	$TemperatureBar.min_value = pipe.min_temperature
	$TemperatureBar.max_value = pipe.max_temperature
	add_to_group(Globulars.PIPE_GROUP)


func _process(delta: float) -> void:
	$TemperatureBar.value = pipe.temperature
	$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_LOW)
	if pipe.temperature > pipe.min_temperature + (pipe.max_temperature - pipe.min_temperature) * 0.2:
		$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_MEDIUM)
	if pipe.temperature > pipe.min_temperature + (pipe.max_temperature - pipe.min_temperature) * 0.8:
		$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_HIGH)


func display() -> void:
	self.modulate.a = 1


func undisplay() -> void:
	self.modulate.a = 0
