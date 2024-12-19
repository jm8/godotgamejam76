extends Panel

var classical = 0
var quantum = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Globulars.qc_heating = 0
	classical = 0
	quantum = 0
	for upgrade in %Upgrades.upgrades:
		Globulars.crypto += delta * upgrade.count * ((upgrade.base_income + upgrade.additive_1) * upgrade.multiplyer_1 * upgrade.multiplyer_2)
		Globulars.qc_heating += upgrade.count * upgrade.waste_energy
		classical += upgrade.count * upgrade.compute
		quantum += upgrade.count * upgrade.quantum

	
	%ResourceLabel.text = "Crypto: %s\nClassical: %s\nQuantum:%s" % [floor(Globulars.crypto), classical, quantum]
	%PowerLabel.text = "%skW" % Globulars.qc_heating
