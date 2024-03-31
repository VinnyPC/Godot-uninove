extends Node2D

onready var lasers = $Lasers
onready var player = $Player

func _on_player_laser_shot(laser):
	lasers.add_child(laser)

func _ready():
	player.connect("laser_shot", self, "_on_player_laser_shot")
