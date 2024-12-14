extends Node2D

@onready var buttons = %TowerButtonsContainer
@onready var tower_description = %TowerDescription
var CreateTowerButton = preload("res://create_tower_button.tscn")

var selected_tower: TowerType

func create_buttons():
	for child in buttons.get_children():
		child.queue_free()
	for tower_type in tower_types:
		var button: Button = CreateTowerButton.instantiate()
		button.icon = tower_type.texture
		button.tooltip_text = tower_type.name
		buttons.add_child(button)
		button.mouse_entered.connect(func():
			if selected_tower == null:
				tower_description.text = tower_type.description
		)
		button.pressed.connect(func():
			selected_tower = tower_type
			tower_description.text = tower_type.description
		)


@export var tower_types: Array[TowerType]:
	set(value):
		tower_types = value
		if buttons != null:
			create_buttons()

func _ready() -> void:
	create_buttons()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		selected_tower = null