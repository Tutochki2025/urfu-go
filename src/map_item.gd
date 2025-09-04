class_name MapItem extends Sprite2D

@export var max_scale: Vector2 = Vector2(1, 1)
@export var min_scale: Vector2 = Vector2(0.2, 0.2)
@export var lonlat: Vector2 = Vector2(0, 0)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func set_pos(streetmap, my_lonlat):
	position = streetmap.lonlat_to_screen(lonlat.x, lonlat.y)

func _on_button_pressed() -> void:
	print(55)


func _on_character_body_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print(56)
