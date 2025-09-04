class_name Main extends Control

@onready var streetmap: MapViewer = get_node("Streetmap")
@onready var mapitems: Node2D = get_node("MapItems")

var gps_provider
var my_lonlat: Vector2 = Vector2(0, 0)

func _ready():
	#The rest of your startup code goes here as usual
	get_tree().on_request_permissions_result.connect(perm_check)
	#NOTE: OS.request_permissions() should be called from a button the user actively touches after being informed of 
	#what the button will enable.  This is placed in _ready() only to indicate this must be called, and how to structur
	#handling the 2 paths code can follow after calling it.
	var allowed = OS.request_permissions() 
	if allowed:
		enableGPS()

func perm_check(permName, wasGranted):
	if permName == "android.permission.ACCESS_FINE_LOCATION" and wasGranted == true:
		enableGPS()

func enableGPS():
	gps_provider = Engine.get_singleton("PraxisMapperGPSPlugin")
	if gps_provider != null:
		gps_provider.onLocationUpdates.connect(new_location)
		gps_provider.StartListening()

func new_location(data: Dictionary):
	my_lonlat = Vector2(data['longitude'], data['latitude'])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	var mousepos = get_local_mouse_position()
	var touch_lonlat = streetmap.screen_to_lonlat(mousepos.x, mousepos.y)
	var dif = touch_lonlat - my_lonlat
	#print(touch_lonlat)
	print(my_lonlat)
	for mapitem in mapitems.get_children():
		mapitem.set_pos(streetmap, my_lonlat)
	#$Sprite2D.position = streetmap.lonlat_to_screen(60.65079, 56.84077)
	#print(dif.length())

func _on_zoom_in_pressed() -> void:
	streetmap.apply_zoom(1.05, DisplayServer.window_get_size()/2)

func _on_zoom_out_pressed() -> void:
	streetmap.apply_zoom(0.95, DisplayServer.window_get_size()/2)


func _on_streetmap_zoom_in() -> void:
	for mapitem in mapitems.get_children():
		mapitem.scale *= 2

func _on_streetmap_zoom_out() -> void:
	for mapitem in mapitems.get_children():
		mapitem.scale /= 2
