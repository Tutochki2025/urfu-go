extends Control

signal egg_open_pressed

var texture: Texture2D
var text: String

@onready var texture_rect: TextureRect = get_node("HBoxContainer/HFlowContainer/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/TextureRect")
@onready var label: Label = get_node("HBoxContainer/HFlowContainer/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/Label")

func setup(texture: Texture2D, text: String):
	self.texture = texture
	self.text = text

func _ready() -> void:
	texture_rect.texture = texture
	label.text = text


func _on_button_pressed() -> void:
	egg_open_pressed.emit()
