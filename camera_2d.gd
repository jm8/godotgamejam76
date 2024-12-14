extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_MIDDLE:
		position -= event.relative / zoom.x
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom *= 1.1
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom *= 0.9

	zoom.x = clamp(zoom.x, 0.1, 2.0)
	zoom.y = clamp(zoom.y, 0.1, 2.0)
