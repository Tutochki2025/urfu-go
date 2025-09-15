class_name MapItem extends Node2D

signal was_claimed(pets)
var claimed := false

@export var lonlat: Vector2 = Vector2(0, 0)
@export var item_resource: ItemResource

@onready var texture: Sprite2D = get_node("Sprite2D")
@onready var egg: Sprite2D = get_node("CanvasLayer/Center/Sprite2D")
@onready var animation:AnimationPlayer = get_node("AnimationPlayer")
@onready var center: Node2D = get_node("CanvasLayer/Center")
@onready var control_text: Control = get_node("CanvasLayer/Text")
@onready var text: Label = get_node("CanvasLayer/Text/VBoxContainer/Label")
@onready var control_dark: Control = get_node("CanvasLayer/Control")
@onready var control_light: Control = get_node("CanvasLayer/Control2")
@onready var info_canvas_layer: CanvasLayer = get_node("InfoCanvasLayer")

@onready var info = preload("res://src/info.tscn")



func _ready() -> void:
	texture.texture = item_resource.egg_image
	egg.texture = item_resource.egg_image
	center.position = DisplayServer.window_get_size()/2

func set_pos(streetmap, my_lonlat):
	global_position = streetmap.lonlat_to_screen(lonlat.x, lonlat.y)
	#scale.x = clamp(scale.x, min_scale.x, max_scale.x)
	#scale.y = clamp(scale.y, min_scale.y, max_scale.y)

func _on_button_pressed() -> void:
	var diff = (Global.my_lonlat - lonlat).length()
	#0.00095
	if not(claimed):# and diff <= 0.00095:
		var info_window = info.instantiate()
		info_window.setup(item_resource.info_image, item_resource.info)
		info_canvas_layer.add_child(info_window)
		info_window.egg_open_pressed.connect(open_egg)

func open_egg():
	for info in info_canvas_layer.get_children():
		info_canvas_layer.remove_child(info)
		info.queue_free()
	animation.play("egg_take_new")
	await animation.animation_finished
	animation.play("egg_opening_1")
	await animation.animation_finished
	animation.play("egg_opening_2")
	await animation.animation_finished
	egg.texture = item_resource.pet_image
	control_text.visible = true
	text.text = item_resource.name
	animation.play("egg_opening_3")
	Global.save_pet(item_resource.id)
	Global.save_game()
	await get_tree().create_timer(2).timeout
	control_text.visible = false
	animation.play_backwards("egg_opening_2")
	await animation.animation_finished
	animation.play_backwards("egg_opening_1")
	await animation.animation_finished
	control_dark.visible = false
	control_light.visible = false
	modulate = Color.DIM_GRAY
	
	was_claimed.emit(Global.save_data['pets'])
	
	claimed = true
