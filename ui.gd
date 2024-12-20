extends Node2D

@onready var buttons = %TowerButtonsContainer
@onready var tower_description = %TowerDescription
@onready var enemy_spawner = get_parent().get_node("EnemySpawner")
var CreateTowerButton = preload("res://create_tower_button.tscn")
var TowerUpgradeButtonScene = preload("res://TowerUpgradeButton.tscn")

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

func _process(_delta: float) -> void:
	if enemy_spawner.is_in_wave:
		%WaveInfo.text = "Wave " + str(enemy_spawner.wave_num) + " ends in " + str(ceil(enemy_spawner.time_til_wave_ends))
	else:
		%WaveInfo.text = "Wave " + str(enemy_spawner.wave_num) + " starts in " + str(ceil(enemy_spawner.time_til_next_wave))

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
	
	for c in %SelectedTowerMenu.get_children():
		if c is TowerUpgradeButton:
			c.queue_free()
	
	var i: int = 0
	for u in tower.upgrades:
		var b: TowerUpgradeButton = TowerUpgradeButtonScene.instantiate()
		b.setup(u)
		b.connect("gui_input", func (event: InputEvent):
			if event is InputEventMouseButton and event.button_mask & MOUSE_BUTTON_MASK_LEFT != 0:
				if not u.purchased and Globulars.crypto >= u.cost:
					Globulars.crypto -= u.cost
					u.purchased = true
					tower.handle_upgrade(i)
					b.setup(u)
		)
		%SelectedTowerMenu.add_child(b)
		i += 1
