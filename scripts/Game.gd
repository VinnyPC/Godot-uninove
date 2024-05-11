extends Node2D

onready var lasers = $Lasers
onready var player = $Player
onready var asteroids = $Asteroids
onready var score_label = $UI/hud/Label
onready var hud = $UI/hud
onready var game_over_screen = $UI/GameOverScreen

var asteroid_scene = preload("res://cenas/Asteroid.tscn")
var score := 0

var lives = 1
func _ready():
	game_over_screen.visible = false
	score = 0
	lives = 1
	player.connect("laser_shot", self, "_on_player_laser_shot")
	player.connect("died", self, "_on_player_died")
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", self, "_on_asteroid_exploded")

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func _on_asteroid_exploded(pos, size):
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				score += 100
				spawn_asteroid(pos, Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				score += 150
				spawn_asteroid(pos, Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				score += 200
				# Spawn a new LARGE asteroid at a random corner of the screen
				randomize()
				var spwn_pos = Vector2(randi() % int(get_viewport().size.x), randi() % int(get_viewport().size.y))
				spawn_asteroid(spwn_pos, Asteroid.AsteroidSize.LARGE)
	score_label.text = "Pontos: " + str(score)
			
func spawn_asteroid(pos, size):
	var a = asteroid_scene.instance()
	a.global_position = pos
	a.size = size
	a.connect("exploded", self, "_on_asteroid_exploded")
	asteroids.add_child(a)
	
func _on_player_died():
	lives -= 1
	print(lives)
	if lives <= 0:
		yield(get_tree().create_timer(1), "timeout")
		game_over_screen.visible = true
		
	
