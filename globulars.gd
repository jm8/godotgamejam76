extends Node

var min_zoom = 0.05
var max_zoom = 2.0
var zoom_change_factor = 0.1

const TOWER_GROUP = "tower"
const PIPE_GROUP = "pipe"

const PROGRESS_HIGH = preload("res://progress_colors/high.tres")
const PROGRESS_MEDIUM = preload("res://progress_colors/medium.tres")
const PROGRESS_LOW = preload("res://progress_colors/low.tres")
const SOUND_COINS = preload("res://sounds/coins.mp3")
const PIPE_COST = 10

@onready var audio_stream = get_node("/root/Node2D/AudioStreamPlayer2D") as AudioStreamPlayer2D

var pipes: Dictionary
var towers_by_position: Dictionary

var crypto: float = 10
var qc_heating: float = 0

func play_coins_sound():
	audio_stream.stream = SOUND_COINS
	audio_stream.play()

func average_temperature(a: Vector2i, b: Vector2i, delta: float):
	var rate = min(pipes[a].transfer_rate, pipes[b].transfer_rate)
	var difference = pipes[a].temperature - pipes[b].temperature
	pipes[a].temperature -= difference * rate * delta / pipes[a].specific_heat
	pipes[b].temperature += difference * rate * delta / pipes[b].specific_heat

func average_temperature_tower(pipe: Pipe, tower: Tower, delta: float):
	var rate = pipe.transfer_rate
	var difference = pipe.temperature - tower.temperature
	pipe.temperature -= difference * rate * delta / pipe.specific_heat
	tower.temperature += difference * rate * delta / tower.specific_heat

func average_temperature_qc(pipe: Pipe, qc: QuantumComputer, delta: float):
	var rate = pipe.transfer_rate
	var difference = pipe.temperature - qc.temperature
	pipe.temperature -= difference * rate * delta / pipe.specific_heat
	qc.temperature += difference * rate * delta / qc.specific_heat
