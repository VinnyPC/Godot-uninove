extends Control

onready var menu = $Menu
func _ready():
	pass # Replace with function body.

func _on_Restart_pressed():
	get_tree().reload_current_scene()
	
#func _process(delta):
#	if Input.is_action_just_pressed("ui_accept"):  # Enter key
#		get_tree().reload_current_scene()
