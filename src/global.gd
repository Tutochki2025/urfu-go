extends Node

signal pet_added(pet_name)

var save_data: Dictionary = {
	'username': '',
	'password': '',
	'pets': [],
	'money': 0,
	'gps_permission': false
}

func save_pet(pet_name: String):
	save_data['pets'].append(pet_name)

func save_game():
	var save_file = FileAccess.open('user://savedata.save', FileAccess.WRITE)
	var json_string = JSON.stringify(save_data)
	save_file.store_line(json_string)

func load_game():
	if not FileAccess.file_exists('user://savedata.save'):
		return
	
	var save_file = FileAccess.open('user://savedata.save', FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			continue
		var load_data = json.data
		
		save_data = load_data
	
	return true
