extends Enemy


var evade_chance = .5
var evade_length = .5
var evade_cooldown = .5

var evading_t = 0
var evading_cooldown_t = 0

func damage(amount: float):
	if evading_cooldown_t == 0:
		# recalculate the evade randomness
		if randf() < evade_chance:
			# succesful evade
			evading_t = evade_length
			evading_cooldown_t = evade_length + evade_cooldown
		else:
			# failed evade
			evading_cooldown_t = evade_cooldown
		
	if evading_t == 0:
		health -= amount

func _process(delta: float) -> void:
	super._process(delta)
	evading_t = max(evading_t - delta, 0)
	evading_cooldown_t = max(evading_cooldown_t - delta, 0)

	rotation = TAU * (1 - evading_t / evade_length)
