extends HBoxContainer

var classical_cost = 500
var quantum_cost = 0

var classical_progress = 0
var quantum_progress = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $PlayButton.button_pressed:
		classical_progress = min(classical_progress + delta * Globulars.classical)
		quantum_progress = min(quantum_progress + delta * Globulars.quantum)
