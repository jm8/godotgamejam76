extends Node2D
class_name DispersingText

const my_scene = preload("res://DispersingText.tscn")

@export var speed = 100
@export var curve: Curve2D

var offset: Vector2
var text: String
var color: Color

var t = 0

static func create(position: Vector2, text: String, color: Color = Color.WHITE) -> DispersingText:
	var dispersing_text = my_scene.instantiate()
	dispersing_text.offset = position
	dispersing_text.text = text
	dispersing_text.color = color
	return dispersing_text


func _ready() -> void:
	global_position = curve.sample_baked(0) + offset
	$Label.text = text
	$Label.add_theme_color_override("font_color", color)


func _process(delta: float) -> void:
	t += delta
	$Label.modulate.a = 1 - ((speed * t) / curve.get_baked_length())
	global_position = curve.sample_baked(speed * t) + offset
	if $Label.modulate.a == 0:
		queue_free()
