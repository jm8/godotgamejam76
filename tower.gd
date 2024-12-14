extends Node
class_name Tower

@export var tower_type: TowerType:
	set(value):
		$Sprite2D.texture = value.texture

@export var tower_tile_position: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group(Globulars.TOWER_GROUP)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
