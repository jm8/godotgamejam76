extends Node

var min_zoom = 0.05
var max_zoom = 2.0
var zoom_change_factor = 0.1

var researching: int = -1

const TOWER_GROUP = "tower"
const PIPE_GROUP = "pipe"

const PROGRESS_HIGH = preload("res://progress_colors/high.tres")
const PROGRESS_MEDIUM = preload("res://progress_colors/medium.tres")
const PROGRESS_LOW = preload("res://progress_colors/low.tres")
const SOUND_COINS = preload("res://sounds/coins.mp3")
const DEATH_SOUND = preload("res://sounds/death.mp3")
const PIPE_COST = 10 #DEPREICETED

@onready var audio_stream = get_node("/root/Node2D/AudioStreamPlayer2D") as AudioStreamPlayer2D

var pipes: Dictionary
var towers_by_position: Dictionary

var crypto: float = 10
var qc_heating: float = 0

var wave_num: int = 1
var PIPE_COST_BASE = 5
var PIPE_COST_COEFFICIENT = 3
var LIMIT_X_RATE: int = 100
var LIMIT_Y_RATE: int = 100
var BASE_LIMIT_X: int = 1000
var BASE_LIMIT_Y: int = 1000

var classical: float = 0
var quantum: float = 0

func play_coins_sound():
	play_sound(SOUND_COINS, -15, randf_range(0.9, 1.1))


func play_get_coins_sound():
	play_sound(SOUND_COINS, -15, randf_range(1.2, 1.3))


func play_death_sound():
	play_sound(DEATH_SOUND, -5, randf_range(1, 2))


static func play_sound(audio: AudioStream, volume_db: float = 0, pitch: float = 1) -> void:
	var audio_player := AudioStreamPlayer2D.new()
	audio_player.stream = audio
	audio_player.pitch_scale = pitch
	audio_player.volume_db = volume_db
	Engine.get_main_loop().root.add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()

func average_temperature(a: Vector2i, b: Vector2i, delta: float):
	var rate = min(pipes[a].transfer_rate, pipes[b].transfer_rate)
	var difference = pipes[a].temperature - pipes[b].temperature
	pipes[a].temperature -= difference * rate * delta / pipes[a].specific_heat
	pipes[b].temperature += difference * rate * delta / pipes[b].specific_heat
	if (pipes[b].temperature > pipes[a].temperature and difference > 0) or (pipes[b].temperature < pipes[a].temperature and difference < 0):
		var avg = (pipes[a].temperature + pipes[b].temperature) / 2
		pipes[a].temperature = avg
		pipes[b].temperature = avg

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

func handle_upgrade(index: int):
	print("finished upgrade ", index)
