extends Node
class_name QuantumComputer;

var temperature: float = 300
var specific_heat: float = 10

var max_health = 20
var health = 20

var progress_bar

func _ready():
	progress_bar = get_parent().get_node("UI/ScreenSpace/ProgressBar")
	progress_bar.max_value = max_health
	progress_bar.value = health

func _physics_process(delta: float):
	var pipe = Globulars.pipes.get(Vector2i(0, 0))
	if pipe:
		Globulars.average_temperature_qc(pipe, self, delta)
	temperature += Globulars.qc_heating * delta;


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		health -= area.get_parent().qc_damage
		area.get_parent().queue_free()
		progress_bar.value = health
