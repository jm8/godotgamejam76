extends Panel

var crypto = 1
var classical = 1
var quantum = 1

var power = 1337

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	crypto += 1  * delta * %Upgrades.counts[0]
	
	classical = %Upgrades.counts[1]
	
	%ResourceLabel.text = "Crypto: %s\nClassical: %s\nQuantum:%s" % [floor(crypto), classical, quantum]
	%PowerLabel.text = "%skW" % power
