extends Node2D
class_name Tower

@export var tower_type: TowerType
	#set(value):
		#$Sprite2D.texture = value.texture

@export var tower_tile_position: Vector2i

var temperature: float = 260

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group(Globulars.TOWER_GROUP)
	pass # Replace with function body.

func _physics_process(delta: float):
	var pipe = Globulars.pipes.get(tower_tile_position)
	if pipe:
		Globulars.average_temperature_tower(pipe, self, delta)
	#print("tower: ", self.temperature)
	temperature -= 2 * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
