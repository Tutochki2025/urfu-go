class_name MapItem extends Node2D


@export var lonlat: Vector2 = Vector2(0, 0)
@export var item_resource: ItemResource

@onready var texture: Sprite2D = get_node("Sprite2D")
@onready var egg: Sprite2D = get_node("CanvasLayer/Center/Sprite2D")
@onready var animation:AnimationPlayer = get_node("AnimationPlayer")
@onready var center: Node2D = get_node("CanvasLayer/Center")

func _ready() -> void:
	texture.texture = item_resource.pet_image
	egg.texture = item_resource.pet_image
	center.position = DisplayServer.window_get_size()/2

func set_pos(streetmap, my_lonlat):
	global_position = streetmap.lonlat_to_screen(lonlat.x, lonlat.y)
	#scale.x = clamp(scale.x, min_scale.x, max_scale.x)
	#scale.y = clamp(scale.y, min_scale.y, max_scale.y)

func _on_button_pressed() -> void:
	animation.play("egg_take_new")
	await animation.animation_finished
	animation.play("egg_opening_1")
	await animation.animation_finished
	animation.play("egg_opening_2")
	#Global.save_pet(item_resource.id)
	#Global.save_game()
