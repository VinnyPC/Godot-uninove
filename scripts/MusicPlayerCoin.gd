extends AudioStreamPlayer

onready var music_player_coin = $MusicPlayerCoin



# Called when the node enters the scene tree for the first time.
func _ready():
	music_player_coin.loop = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
