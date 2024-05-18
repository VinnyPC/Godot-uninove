extends Node2D

enum PowerUpTypes {INVENCIBILIDADE, VIDA}
export var PowerUpType := PowerUpTypes.VIDA

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		apply_power_up(body)
		queue_free()

func apply_power_up(player):
	match PowerUpType:
		PowerUpTypes.INVENCIBILIDADE:
			player.start_invincibility()
		PowerUpTypes.VIDA:
			player.gain_extra_life()
