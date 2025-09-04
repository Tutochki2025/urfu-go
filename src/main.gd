class_name Main extends Control

@onready var streetmap: MapViewer = get_node("Streetmap")
@onready var mapitems: Node2D = get_node("MapItems")

@onready var itemcontainer: HBoxContainer = get_node("Streetmap/MarginContainer/VBoxContainer/HBoxContainer3/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/ItemContainer")
@onready var myitem = preload("res://src/my_item.tscn")

@export var itemreses: Array[ItemResource]

@onready var output = get_node("MarginContainer/VBoxContainer/Output")
@onready var output2 = get_node("MarginContainer/VBoxContainer/Output2")

var gps_provider

var dragging := false

func _ready():
	Global.load_game()
	Global.save_game()
	load_eggs(Global.save_data['pets'])
	load_items(Global.save_data['pets'])
	
	for mapitem in mapitems.get_children():
		if mapitem.has_signal('was_claimed'):
			mapitem.was_claimed.connect(load_items)
	
	# GPS load
	get_tree().on_request_permissions_result.connect(perm_check)
	#NOTE: OS.request_permissions() should be called from a button the user actively touches after being informed of 
	#what the button will enable.  This is placed in _ready() only to indicate this must be called, and how to structur
	#handling the 2 paths code can follow after calling it.
	var allowed = OS.request_permissions() 
	if allowed:
		Global.save_data['permission'] = true
		Global.save_game()
		enableGPS()
	
	printo('Tried to get gps permission')
	if Global.save_data['permission']:
		printo('Already got GPS permission')
		enableGPS()

func perm_check(permName, wasGranted):
	if permName == "android.permission.ACCESS_FINE_LOCATION" and wasGranted == true:
		Global.save_data['permission'] = true
		Global.save_game()
		enableGPS()

func enableGPS():
	printo('enableGPS')
	gps_provider = Engine.get_singleton("PraxisMapperGPSPlugin")
	if gps_provider != null:
		printo('GPS listening started')
		gps_provider.onLocationUpdates.connect(new_location)
		gps_provider.StartListening()

func new_location(data: Dictionary):
	Global.my_lonlat = Vector2(data['longitude'], data['latitude'])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var mousepos = get_local_mouse_position()
	var touch_lonlat = streetmap.screen_to_lonlat(mousepos.x, mousepos.y)
	var dif = touch_lonlat - Global.my_lonlat
	
	var str = ''
	for mapitem in mapitems.get_children():
		if mapitem is MapItem:
			str += str((Global.my_lonlat-mapitem.lonlat).length()) + ' '
		mapitem.set_pos(streetmap, Global.my_lonlat)
	#$Sprite2D.position = streetmap.lonlat_to_screen(60.65079, 56.84077)
	#printo2(str((Global.my_lonlat-touch_lonlat).length()))
	printo2(touch_lonlat)
	if dragging:
		streetmap.queue_redraw()

func _on_zoom_in_pressed() -> void:
	streetmap.apply_zoom(1.05, DisplayServer.window_get_size()/2)

func _on_zoom_out_pressed() -> void:
	streetmap.apply_zoom(0.95, DisplayServer.window_get_size()/2)

func _on_streetmap_zoom_in() -> void:
	for mapitem in mapitems.get_children():
		mapitem.scale *= 1.85

func _on_streetmap_zoom_out() -> void:
	for mapitem in mapitems.get_children():
		mapitem.scale /= 1.85

func load_eggs(pets):
	for mapitem in mapitems.get_children():
		if mapitem.name in pets:
			mapitem.modulate = Color.DIM_GRAY
			mapitem.claimed = true

func load_items(pets):
	print(pets)
	for item in itemcontainer.get_children():
		itemcontainer.remove_child(item)
		item.queue_free()
	for id in pets:
		var item: MyItem = myitem.instantiate()
		print(1)
		for itemres in itemreses:
			print(itemres.id)
			if itemres.id == id:
				item.set_texture(itemres.pet_image)
				item.set_text(itemres.name)
		itemcontainer.add_child(item)


func _on_gps_pressed() -> void:
	var xy = streetmap.lonlat_to_world(Global.my_lonlat.x, Global.my_lonlat.y)
	var tween = get_tree().create_tween()
	tween.tween_property(streetmap, "_xyz", Vector3(xy.x, xy.y, streetmap._xyz.z), 1.0).set_trans(Tween.TRANS_SINE)
	dragging = true
	tween.tween_property(self, "dragging", false, 0.0)
	#streetmap._xyz = Vector3(xy.x, xy.y, streetmap._xyz.z)

func printo(text):
	output.text = output.text + '\n' + str(text)
	
func printo2(text):
	output2.text = str(text)
