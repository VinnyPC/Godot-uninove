# Script do Menu
extends Node2D

onready var start_label = $StartLabel
onready var coin_label = $CoinLabel
onready var blink_timer = $BlinkTimer
onready var music_player_menu = $MusicPlayerMenu
onready var music_player_coin = $MusicPlayerCoin

export var coin_count = 0
var insert_coin_text = "inserir ficha"
var start_game_text = "aperte enter"
var showing_insert_coin_text = true

signal coin_inserted
signal game_start(coin_count)

func _ready():
	blink_timer.connect("timeout", self, "_on_blink_timer_timeout")
	blink_timer.start()
	music_player_menu.play()

func _on_blink_timer_timeout():
	if showing_insert_coin_text:
		start_label.visible = not start_label.visible

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  # Enter key
		if coin_count > 0 and start_label.text == start_game_text:
			emit_signal("game_start", coin_count)
			music_player_menu.stop()
			var game_scene = load("res://cenas/Game.tscn").instance()  # Carrega a cena do jogo
			game_scene.set("lives", coin_count)  # Define as vidas no script da cena do jogo
			get_tree().root.add_child(game_scene)  # Adiciona a cena ao root
			queue_free()  # Libera a cena atual do menu
	if Input.is_action_just_pressed("insert_coin"):  # F key
		music_player_coin.play()
		coin_count += 1
		coin_label.text = "Fichas: " + str(coin_count)
		start_label.text = start_game_text
		start_label.visible = true
		showing_insert_coin_text = false
		emit_signal("coin_inserted")
