class_name Player extends KinematicBody2D

signal laser_shot(laser)
signal died
# Declaração de variaveis
export var acceleration := 10.0
export var max_speed := 350.0
export var rotation_speed := 230.00
var velocity = Vector2()

onready var game = $Game
onready var muzzle = $Muzzle
onready var sprite = $Sprite

var laser_scene = preload("res://cenas/Laser.tscn")
var alive := true

var is_invincible = false
var machine_gun_enabled = false
var invincibility_timer = Timer.new()
var machine_gun_timer = Timer.new()

func _ready():
	add_child(invincibility_timer)
	add_child(machine_gun_timer)
	invincibility_timer.connect("timeout", self, "_end_invincibility")
	machine_gun_timer.connect("timeout", self, "_disable_machine_gun")

func _process(delta):
	if Input.is_action_just_pressed("atirar"):
		shoot_laser()
	elif machine_gun_enabled and Input.is_action_pressed("atirar"):
		shoot_laser()

func _physics_process(delta):
	# entrada do jogador para mover para frente ou para trás
	var input_vector := Vector2(0, Input.get_axis("mover_frente", "mover_tras"))
	

	# Adiciona a aceleração a velocidade com base na entrada do jogador dando a impressao de aceleração
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

func shoot_laser():
	var l = laser_scene.instance()
	l.global_position = muzzle.global_position
	l.rotation = rotation
	get_tree().root.add_child(l)
	emit_signal("laser_shot", l)

func die():
	if alive==true:
		alive = false
		emit_signal("died")
		sprite.visible = false
		set_process(false)
		
func respawn(pos):
	if alive==false:
		alive = true
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		set_process(true)
		

func start_invincibility():
	is_invincible = true
	invincibility_timer.start(5)  # Invencibilidade dura 5 segundos

func _end_invincibility():
	is_invincible = false

func enable_machine_gun():
	machine_gun_enabled = true
	machine_gun_timer.start(10)  # Metralhadora dura 10 segundos

func _disable_machine_gun():
	machine_gun_enabled = false

func gain_extra_life():
	game.player_lives += 1
