extends Control

onready var menu = $Menu
onready var music_player = $MusicPlayer
func _ready():
	pass

func _on_Restart_pressed():
	get_tree().reload_current_scene()
	
func _process(delta):
	if Input.is_action_just_pressed("insert_coin"):
		reset_game()
		queue_free()

func reset_game():
	var menu_scene = load("res://cenas/Menu.tscn").instance()
	get_tree().root.add_child(menu_scene)
	queue_free()
	
