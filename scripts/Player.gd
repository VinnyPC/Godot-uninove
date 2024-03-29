extends KinematicBody2D

# Declaração de variaveis
export var acceleration := 10.0
export var max_speed := 350.0
export var rotation_speed := 230.00
var velocity = Vector2()

func _physics_process(delta):
	var input_vector := Vector2(0, Input.get_axis("mover_frente", "mover_tras"))
	

	# Adiciona a aceleração à velocidade com base na entrada do jogador dando a impressao de aceleração
	# (igual uma nave msm kkkk)
	velocity += input_vector.rotated(rotation) * acceleration
	# Limita a velocidade máxima
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("girar_direita"):
		rotate(deg2rad(rotation_speed*delta))
		
	if Input.is_action_pressed("girar_esquerda"):
		rotate(deg2rad(-rotation_speed*delta))
	
	# Se o jogador não estiver pressionando nenhum botão a nave desacelera
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	move_and_slide(velocity)

	# Verifica se o jogador atingiu os limites da tela e teleporta para o lado oposto
	var screen_size = get_viewport_rect().size
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y:
		global_position.y = 0
		
	if global_position.x < 0:
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x:
		global_position.x = 0
