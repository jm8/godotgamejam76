extends Tower

func set_temperature(value):
	var previous_range = get_temperature_range(temperature)
	var next_range = get_temperature_range(value)
	if previous_range != next_range:
		set_bar_style(next_range)
	return value

enum TemperatureRange {
	Low,
	Medium,
	High
}

var transfer_rate: float = 6
var efficency: float = 0.5

func set_bar_style(temperature_range: TemperatureRange):
	match temperature_range:
		TemperatureRange.Low:
			$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_LOW)
		TemperatureRange.Medium:
			$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_MEDIUM)
		TemperatureRange.High:
			$TemperatureBar.add_theme_stylebox_override("fill", Globulars.PROGRESS_HIGH)

func get_temperature_range(t: float) -> TemperatureRange:
	var temperature_range = TemperatureRange.Low
	if t > operating_temperature:
		temperature_range = TemperatureRange.Medium
	if t > min_temperature + (max_temperature - min_temperature) * 0.8:
		temperature_range = TemperatureRange.High
	return temperature_range

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TemperatureBar.min_value = min_temperature
	$TemperatureBar.max_value = max_temperature
	set_bar_style(get_temperature_range(temperature))

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	transfer_heat(delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if temperature < min_temperature:
		delete()
		return
	$TemperatureBar.value = temperature

func transfer_heat(delta: float) -> void:
	var qc = get_tree().root.get_node("Node2D/QuantumComputer")
	var difference = temperature - qc.temperature
	if difference < 0:
		temperature -= efficency * difference * transfer_rate * delta / specific_heat
		qc.temperature += difference * transfer_rate * delta / qc.specific_heat
