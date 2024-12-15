extends Node
class_name QuantumComputer;

var temperature: float = 1000

func _physics_process(delta: float):
	var pipe = Globulars.pipes.get(Vector2i(0, 0))
	if pipe:
		Globulars.average_temperature_qc(pipe, self, delta)
	print("qc: ", self.temperature)
	temperature += 20 * delta;
