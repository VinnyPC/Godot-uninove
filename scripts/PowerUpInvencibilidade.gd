extends Area2D

onready var Player = $Player
# Definindo os tipos de power-ups
enum PowerUpTypes { INVENCIBILIDADE, VIDA }
export var PowerUpType := PowerUpTypes.VIDA

# Tempo de duração do power-up de invencibilidade em segundos
export var invincibility_duration := 5.0

# Função chamada quando o nó é adicionado à cena
func _ready():
	connect("body_entered", self, "_on_body_entered")

# Função chamada quando um corpo entra na área
func _on_body_entered(body):
	if body.name == "Player":
		apply_power_up(body)
		queue_free()  # Remove o power-up da cena após aplicação

# Função para aplicar o power-up no jogador
func apply_power_up(player):
	match PowerUpType:
		PowerUpTypes.INVENCIBILIDADE:
			player.start_invincibility(invincibility_duration)
		PowerUpTypes.VIDA:
			player.gain_extra_life()
