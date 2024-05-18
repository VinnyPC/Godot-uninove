extends Area2D

var movement_vector := Vector2(0, -1)
export var speed := 500.0

func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Laser_area_entered(area):
	if area is Asteroid:
		var asteroid = area
		asteroid.explode()
		queue_free()
	elif area is UFO:
		var ufo = area
		ufo.die()
		queue_free()
		


