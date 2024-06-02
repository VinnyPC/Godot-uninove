extends Area2D

# Definindo os tipos de power-ups
enum PowerUpTypes { INVENCIBILIDADE, VELOCIDADE, VIDA }

# Exportando variáveis para configuração no editor
export var PowerUpType := PowerUpTypes.VIDA
export var invincibility_duration := 5.0
export var respawn_time := 10.0
export var respawn_animation_time := 1.0

# Variáveis internas para controle do respawn
var respawn_timer := 0.0
var can_respawn := true

# Função chamada quando o nó é adicionado à cena
func _ready():
	connect("body_entered", self, "_on_body_entered")

# Função chamada a cada frame
func _process(delta):
	if !can_respawn:
		respawn_timer += delta
		if respawn_timer >= respawn_time:
			can_respawn = true
			respawn_timer = 0.0

# Função chamada quando um corpo entra na área
func _on_body_entered(body):
	if body.has_method("apply_power_up"):
		apply_power_up(body)
		if PowerUpType == PowerUpTypes.VIDA:
			respawn_timer = 0.0
			can_respawn = false
			$Sprite.modulate = Color(1, 1, 1, 0)  # Oculta o sprite durante o tempo de respawn
			$RespawnTimer.start()  # Inicia a animação de respawn

# Função para aplicar o power-up no jogador
func apply_power_up(player):
	match PowerUpType:
		PowerUpTypes.INVENCIBILIDADE:
			player.start_invincibility(invincibility_duration)
		PowerUpTypes.VELOCIDADE:
			player.activate_speed_boost()
		PowerUpTypes.VIDA:
			player.gain_extra_life()

# Função chamada quando o temporizador de respawn termina
func _on_RespawnTimer_timeout():
	$Sprite.modulate = Color(1, 1, 1, 1)  # Exibe o sprite após o tempo de respawn
