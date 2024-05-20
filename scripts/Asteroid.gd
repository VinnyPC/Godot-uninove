class_name Asteroid extends Area2D

signal exploded(pos, size)

var movement_vector := Vector2(0, -1)

enum AsteroidSize { LARGE, MEDIUM, SMALL }
export var size := AsteroidSize.LARGE
onready var sprite = $Sprite
onready var cshape = $CollisionShape2D
onready var Player = get_node_or_null("res://cenas/Player.tscn")
onready var explosionSound = $ExplosionSound

var speed := 50

func _ready():
	randomize()
	rotation = rand_range(0, 2 * PI)
	
	match size:
		AsteroidSize.LARGE:
			speed = rand_range(50, 100)
			sprite.texture = preload("res://assets/PNG/Meteors/larg_asteroid_1.png")
			cshape.set_deferred("shape", preload("res://recursos/Asteroid_cshape_large.tres"))
		AsteroidSize.MEDIUM:
			speed = rand_range(100, 150)
			var medium_asteroid = randi() % 3
			match medium_asteroid:
				0:
					sprite.texture = preload("res://assets/PNG/Meteors/medium_asteroid_1.png")
				1:
					sprite.texture = preload("res://assets/PNG/Meteors/medium_asteroid_2.png")
				2:
					sprite.texture = preload("res://assets/PNG/Meteors/medium_asteroid_3.png")
			cshape.set_deferred("shape", preload("res://recursos/Asteroid_cshape_medium.tres"))
		AsteroidSize.SMALL:
			speed = rand_range(100, 200)
			var small_asteroid = randi() % 3
			match small_asteroid:
				0:
					sprite.texture = preload("res://assets/PNG/Meteors/small_asteroid_1.png")
				1:
					sprite.texture = preload("res://assets/PNG/Meteors/small_asteroid_2.png")
				2:
					sprite.texture = preload("res://assets/PNG/Meteors/small_asteroid_3.png")
			cshape.set_deferred("shape", preload("res://recursos/Asteroid_cshape_small.tres"))

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var radius = cshape.shape.radius
	var screen_size = get_viewport_rect().size
	if (global_position.y + radius) < 0:
		global_position.y = (screen_size.y + radius)
	elif (global_position.y - radius) > screen_size.y:
		global_position.y = -radius
		
	if (global_position.x + radius) < 0:
		global_position.x = (screen_size.x + radius)
	elif (global_position.x - radius) > screen_size.x:
		global_position.x = -radius
		
func explode():
	emit_signal("exploded", global_position, size)
	explosionSound.play()
	queue_free()

func _on_Asteroid_body_entered(body):
	if body.name == "Player":
		var player = body
		if player.is_invincible:
			print("Player is invincible")
		else:
			player.die()
