extends Resource
class_name TowerUpgrade

var purchased: bool
var cost: float
var name: String
var description: String

func _init(n: String, d: String, c: float) -> void:
	name = n
	description = d
	cost = c
