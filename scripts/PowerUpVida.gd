extends Area2D

onready var Player = $Player
# Tempo de respawn do power-up em segundos
export var respawn_time := 10.0

var respawn_timer := 0.0
var can_respawn := true

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
	if !can_respawn:
		respawn_timer += delta
		if respawn_timer >= respawn_time:
			can_respawn = true
			respawn_timer = 0.0
			respawn()  # Chama a função de respawn quando o timer expira

func _on_body_entered(body):
	if body.name == "Player":
		apply_power_up(body)
		respawn_timer = 0.0
		can_respawn = false
		queue_free()

func apply_power_up(player):
	if player.has_method("gain_extra_life"):
		player.gain_extra_life()

func respawn():
	if can_respawn:
		var new_power_up = duplicate()
		new_power_up.position = position  # Mantém a mesma posição
		get_parent().add_child(new_power_up)  # Adiciona o novo power-up ao nível
