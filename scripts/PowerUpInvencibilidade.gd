extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		apply_power_up(body)
		queue_free()

func apply_power_up(player):
	player.start_invincibility()
	queue_free()
