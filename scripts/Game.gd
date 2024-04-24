extends Node2D

onready var lasers = $Lasers
onready var player = $Player
onready var asteroids = $Asteroids
onready var score_label = $UI/hud/Label

var asteroid_scene = preload("res://cenas/Asteroid.tscn")
var score := 0


func _on_player_laser_shot(laser):
	lasers.add_child(laser)
	
func _ready():
	score = 0
	player.connect("laser_shot", self, "_on_player_laser_shot")
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", self, "_on_asteroid_exploded")
		

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
				pass
	score_label.text = "Score: " + str(score)
			
func spawn_asteroid(pos, size):
	var a = asteroid_scene.instance()
	a.global_position = pos
	a.size = size
	a.connect("exploded", self, "_on_asteroid_exploded")
	asteroids.add_child(a)
