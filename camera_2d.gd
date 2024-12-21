extends Camera2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_MIDDLE:
		position -= event.relative / zoom.x
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom *= (1 + Globulars.zoom_change_factor)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom *= (1 - Globulars.zoom_change_factor)

	zoom.x = clamp(zoom.x, Globulars.min_zoom, Globulars.max_zoom)
	zoom.y = clamp(zoom.y, Globulars.min_zoom, Globulars.max_zoom)
	limit_top = -Globulars.BASE_LIMIT_Y - Globulars.LIMIT_Y_RATE * Globulars.wave_num
	limit_bottom = Globulars.BASE_LIMIT_Y + Globulars.LIMIT_Y_RATE * Globulars.wave_num
	limit_left = -Globulars.BASE_LIMIT_X - Globulars.LIMIT_X_RATE * Globulars.wave_num
	limit_right = Globulars.BASE_LIMIT_X + Globulars.LIMIT_X_RATE * Globulars.wave_num
	Globulars.min_zoom = .9 - 0.1 * Globulars.wave_num
	
