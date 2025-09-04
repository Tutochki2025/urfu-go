extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_pos(streetmap, my_lonlat):
	position = streetmap.lonlat_to_screen(my_lonlat.x, my_lonlat.y)
	#await animation.animation_finishedvar z = streetmap._xyz.z
	#if z < 15:
	#	scale = Vector2(0.02, 0.02)*z**2
	#else:
	#	scale = Vector2(0.04, 0.04)*z**2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
