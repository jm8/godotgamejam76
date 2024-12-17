extends Node2D

@onready var buttons = %TowerButtonsContainer
@onready var tower_description = %TowerDescription
var CreateTowerButton = preload("res://create_tower_button.tscn")

var placing_tower_type: TowerType
var selected_tower: Tower

func create_buttons():
	for child in buttons.get_children():
		child.queue_free()
	print(tower_types)
	for tower_type in tower_types:
		var button: Button = CreateTowerButton.instantiate()
		button.icon = tower_type.texture
		button.tooltip_text = tower_type.name
		buttons.add_child(button)
		button.mouse_entered.connect(func():
			if placing_tower_type == null:
				tower_description.text = tower_type.description
		)
		button.pressed.connect(func():
			if placing_tower_type != null and placing_tower_type.name == tower_type.name:
				placing_tower_type = null
			else:
				placing_tower_type = tower_type
				tower_description.text = tower_type.description
		)


@export var tower_types: Array[TowerType]

func _ready() -> void:
	create_buttons()

	%OpenRightPanelButton.pressed.connect(open_place_panel)
	%CloseButton.pressed.connect(close_right_panel)
	%DeleteButton.pressed.connect(func():
		selected_tower.delete()
		close_right_panel()
	)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed && event.keycode == KEY_ESCAPE:
		placing_tower_type = null

func close_right_panel() -> void:
	%RightPanel.visible = false
	%OpenRightPanelButton.visible = true
	%SelectedTowerMenu.visible = false
	placing_tower_type = null
	selected_tower = null

func open_place_panel() -> void:
	%RightPanel.visible = true
	%OpenRightPanelButton.visible = false
	%PlaceTowerMenu.visible = true
	%SelectedTowerMenu.visible = false

func open_tower_panel(tower: Tower) -> void:
	selected_tower = tower
	%RightPanel.visible = true
	%OpenRightPanelButton.visible = false
	%PlaceTowerMenu.visible = false
	%SelectedTowerDescription.text = tower.tower_type.name
	%SelectedTowerMenu.visible = true
