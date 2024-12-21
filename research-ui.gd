extends VBoxContainer

@export var research_opportunities: Array[ResearchOpportunity] = []

@onready var research_scene = preload("res://research.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for r in research_opportunities:
		var research: Research = research_scene.instantiate()
		research.setup(r, i)
		add_child(research)
		i += 1
