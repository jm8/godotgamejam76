extends VBoxContainer

@export var upgrades: Array[Upgrade]

@onready var upgrade_scene = preload("res://upgrade.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for upgrade in upgrades:
		var b = upgrade_scene.instantiate()
		b.get_node("Left/Title").text = upgrade.name
		b.get_node("Left/Description").text = upgrade.description
		b.get_node("Right/Count").text = str(upgrade.count)
		b.get_node("Right/Cost").text = str(floor(upgrade.base_price * pow(1.1, upgrade.count)))
		b.connect("gui_input", func (event: InputEvent):
			if event is InputEventMouseButton and event.button_mask & MOUSE_BUTTON_MASK_LEFT != 0:
				var cost = floor(upgrade.base_price * pow(1.1, upgrade.count))
				if Globulars.crypto >= cost:
					upgrade.count += 1
					Globulars.crypto -= cost
					b.get_node("Right/Count").text = str(upgrade.count)
					b.get_node("Right/Cost").text = str(floor(upgrade.base_price * pow(1.1, upgrade.count)))
		)
		b.tooltip_text = upgrade.tooltip + "\nWaste Energy:" + str(upgrade.waste_energy) + "\nBase Income: " + str(upgrade.base_income) + "\nReal Income: " + str((upgrade.base_income + upgrade.additive_1) * upgrade.multiplyer_1 * upgrade.multiplyer_2)
		add_child(b)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
