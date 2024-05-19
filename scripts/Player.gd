extends KinematicBody2D

signal laser_shot(laser)
signal died
# Declaração de variáveis
export var acceleration := 10.0
export var max_speed := 350.0
export var rotation_speed := 230.00
var velocity = Vector2()

onready var muzzle = $Muzzle
onready var sprite = $Sprite
onready var spritePropulsor = $Propulsor

var laser_scene = preload("res://cenas/Laser.tscn")
var alive := true

var is_invincible = false
var invincibility_duration = 5
var invincibility_timer = Timer.new()

onready var game = get_tree().get_root().get_node("Game")

func _ready():
	add_child(invincibility_timer)
	invincibility_timer.connect("timeout", self, "end_invincibility")

func _process(delta):
	
	if Input.is_action_just_pressed("atirar"):
		shoot_laser()

func _physics_process(delta):
	# entrada do jogador para mover para frente ou para trás
	var input_vector := Vector2(0, Input.get_axis("mover_frente", "mover_tras"))

	# Adiciona a aceleração a velocidade com base na entrada do jogador dando a impressão de aceleração
	velocity += input_vector.rotated(rotation) * acceleration
	# Limita a velocidade máxima
	velocity = velocity.limit_length(max_speed)
	
	if Input.is_action_pressed("mover_frente"):
		spritePropulsor.visible = true
	else:
		spritePropulsor.visible = false
	
	if Input.is_action_pressed("girar_direita"):
		rotate(deg2rad(rotation_speed * delta))
		
	if Input.is_action_pressed("girar_esquerda"):
		rotate(deg2rad(-rotation_speed * delta))
	
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

func shoot_laser():
	var l = laser_scene.instance()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	get_tree().root.add_child(l)
	emit_signal("laser_shot", l)

func die():
	if alive == true:
		alive = false
		emit_signal("died")
		sprite.visible = false
		set_process(false)
		check_respawn()  # Verifica se deve respawnar o jogador após a morte

func check_respawn():
	if game.lives > 0:
		var respawn_position = get_valid_respawn_position()
		if respawn_position != Vector2.ZERO:
			respawn(respawn_position)
		else:
			print("Não foi possível encontrar uma posição válida de respawn.")
	else:
		print("Game Over")
		
func get_valid_respawn_position():
	var center_screen = get_viewport_rect().size / 2
	var respawn_position = center_screen
	var attempts = 10  # Limite de tentativas para encontrar uma posição válida
	
	while attempts > 0:
		if !is_colliding_with_asteroid(respawn_position):
			return respawn_position
		respawn_position = generate_random_position_around_center(center_screen)
		attempts -= 1
	
	return Vector2.ZERO

func is_colliding_with_asteroid(position):
	var asteroids = get_tree().get_nodes_in_group("Asteroids")
	for asteroid in asteroids:
		if asteroid.get_collision_shape_2d(0).collide_point(position):
			return true
	return false

func generate_random_position_around_center(center):
	var screen_size = get_viewport_rect().size
	var offset = Vector2(rand_range(-screen_size.x / 2, screen_size.x / 2), rand_range(-screen_size.y / 2, screen_size.y / 2))
	return center + offset

func respawn(pos):
	if alive == false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		set_process(true)
		start_invincibility()
		
func start_invincibility():
	is_invincible = true
	invincibility_timer.start(invincibility_duration)   # Invencibilidade dura 5 segundos

func end_invincibility():
	is_invincible = false

func gain_extra_life():
	game.lives += 1
