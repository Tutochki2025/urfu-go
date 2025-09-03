class_name MapItem extends Sprite2D

@export var max_scale: Vector2 = Vector2(1, 1)
@export var min_scale: Vector2 = Vector2(0.2, 0.2)
@export var lonlat: Vector2 = Vector2(0, 0)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func set_zoom(streetmap):
	position = streetmap.lonlat_to_screen(lonlat.x, lonlat.y)
	var z = streetmap._xyz.z
	if z < 15:
		scale = Vector2(0.02, 0.02)*max(1, z)
	else:
		scale = Vector2(0.04, 0.04)*max(1, z)
