extends Panel

var classical = 0
var quantum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var asics = %Upgrades.counts[0]
	var cpus = %Upgrades.counts[1]
	
	Globulars.crypto += 1 * delta * asics
	
	Globulars.qc_heating = asics + 1.5 * cpus + 1
	
	classical = %Upgrades.counts[1]
	
	%ResourceLabel.text = "Crypto: %s\nClassical: %s\nQuantum:%s" % [floor(Globulars.crypto), classical, quantum]
	%PowerLabel.text = "%skW" % Globulars.qc_heating
