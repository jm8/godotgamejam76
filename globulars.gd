extends Node

var min_zoom = .1
var max_zoom = 1.0
var zoom_change_factor = 0.1

const TOWER_GROUP = "tower"

var pipes: Dictionary 

func average_temperature(a: Vector2i, b: Vector2i, delta: float):
	var rate = min(pipes[a].transfer_rate, pipes[b].transfer_rate)
	var difference = pipes[a].temperature - pipes[b].temperature
	pipes[a].temperature -= difference * rate * delta
	pipes[b].temperature += difference * rate * delta

func average_temperature_tower(pipe: Pipe, tower: Tower, delta: float):
	var rate = pipe.transfer_rate
	var difference = pipe.temperature - tower.temperature
	pipe.temperature -= difference * rate * delta
	tower.temperature += difference * rate * delta

func average_temperature_qc(pipe: Pipe, qc: QuantumComputer, delta: float):
	var rate = pipe.transfer_rate
	var difference = pipe.temperature - qc.temperature
	pipe.temperature -= difference * rate * delta
	qc.temperature += difference * rate * delta
