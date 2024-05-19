extends Node2D

onready var start_label = $StartLabel
onready var coin_label = $CoinLabel
onready var blink_timer = $BlinkTimer

var coin_count = 0
var insert_coin_text = "inserir ficha"
var start_game_text = "aperte enter"
var showing_insert_coin_text = true

func _ready():
	blink_timer.connect("timeout", self, "_on_blink_timer_timeout")
	blink_timer.start()

func _on_blink_timer_timeout():
	if showing_insert_coin_text:
		start_label.visible = not start_label.visible

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  # Enter key
		if coin_count > 0 and start_label.text == start_game_text:
			get_tree().change_scene("res://cenas/Game.tscn")  # Altere para o caminho da sua cena do jogo
	if Input.is_action_just_pressed("insert_coin"):  # F key
		coin_count += 1
		coin_label.text = "Fichas: " + str(coin_count)
		start_label.text = start_game_text
		start_label.visible = true
		showing_insert_coin_text = false

