class_name UFO extends Area2D

#velocidade do UFO
export var speed: float = 400.0
#timer max e min para o ufo
export var min_interval: float = 20.0
export var max_interval: float = 30.0
onready var Laser = get_node_or_null("res://cenas/Laser.tscn")

# Tamanho da tela
var screen_size: Vector2

# Timer pra controlar o tempo q o ufo aparece
var ufo_timer: Timer

func _ready():
	#encontra o tamanho da tela
	screen_size = get_viewport_rect().size
	
	# timer pra controlar o spawn do ufo
	ufo_timer = Timer.new()
	add_child(ufo_timer)
	ufo_timer.connect("timeout", self, "_on_UFO_timer_timeout")
	
	#sinal de colisao do UFO
	connect("body_entered", self, "_on_body_entered")
	
	_reset_timer()

#quando o timer termina
func _on_UFO_timer_timeout():
	_spawn_ufo()
	_reset_timer()

#redefinir o timer com um intervalo aleatório
func _reset_timer():
	ufo_timer.start(rand_range(min_interval, max_interval))

#spawnar o UFO fora da tela
func _spawn_ufo():
	position = Vector2(screen_size.x + 50, rand_range(0, screen_size.y))
	show()

func _process(delta):
	position.x -= speed * delta

	# Verifica se o UFO saiu da tela pela esquerda
	if position.x < -self.get_node("Sprite").texture.get_size().x: 
		hide()
		position.x = screen_size.x + 50

func _on_UFO_body_entered(body):
	if (body.name=="Laser"):
		die()

func die():
	queue_free() 



