extends VBoxContainer

@export var upgrades: Array[Upgrade]

@onready var upgrade_scene = preload("res://upgrade.tscn")

var counts: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for upgrade in upgrades:
		counts.append(0)
		var b = upgrade_scene.instantiate()
		b.get_node("Left/Title").text = upgrade.name
		b.get_node("Left/Description").text = upgrade.description
		b.get_node("Right/Count").text = str(counts[i])
		b.get_node("Right/Cost").text = str(floor(upgrade.base_price * pow(1.1, counts[i])))
		b.connect("gui_input", func (event: InputEvent):
			if event is InputEventMouseButton and event.button_mask & MOUSE_BUTTON_MASK_LEFT != 0:
				var cost = floor(upgrade.base_price * pow(1.1, counts[i]))
				if Globulars.crypto >= cost:
					counts[i] += 1
					Globulars.crypto -= cost
					b.get_node("Right/Count").text = str(counts[i])
					b.get_node("Right/Cost").text = str(floor(upgrade.base_price * pow(1.1, counts[i])))
		)
		b.tooltip_text = upgrade.tooltip
		add_child(b)
		i+=1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
