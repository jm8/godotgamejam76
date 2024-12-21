extends HBoxContainer
class_name Research

var classical_cost = 500
var quantum_cost = 0

var classical_progress = 0
var quantum_progress = 0

var index

var finished = false

func setup(r: ResearchOpportunity, i: int):
	classical_cost = r.classical_cost
	quantum_cost = r.quantum_cost
	$Left/Title.text = r.name
	$Left/Description.text = r.description
	var c = "%s classical" % r.classical_cost if classical_cost != 0 else ""
	var q = "%s quantum" % r.quantum if quantum_cost != 0 else ""
	$Center/Cost.text = "%s %s" % [c, q]
	$Center/Progress.text = "0%"
	index = i

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if finished:
		return
	
	if Globulars.researching == index:
		classical_progress = min(classical_cost, classical_progress + delta * Globulars.classical)
		quantum_progress = min(quantum_cost, quantum_progress + delta * Globulars.quantum)
		var proportion = ((classical_progress + quantum_progress) / (classical_cost + quantum_cost))
		$Center/Progress.text = "%s%%" % floor(proportion * 100)
		if proportion == 1.0:
			$Center/Progress.text = "finished"
			$Center/Cost.text = ""
			$PlayButton.visible = false
			Globulars.handle_upgrade(index)
			finished = true
		return
	else:
		$PlayButton.button_pressed = false


func _on_play_button_pressed() -> void:
	if $PlayButton.button_pressed:
		Globulars.researching = index
	else:
		Globulars.researching = -1
