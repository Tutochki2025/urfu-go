class_name MyItem extends VBoxContainer

@onready var texturerect: TextureRect = get_node("TextureRect")
@onready var label: Label = get_node("Label")

var texture: Texture2D
var text: String

func _ready() -> void:
	texturerect.texture = texture
	label.text = text

func set_texture(texture_arg: Texture2D):
	texture = texture_arg
	
func set_text(text_arg: String):
	text = text_arg
