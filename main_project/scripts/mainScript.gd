extends Node


func _ready():
	pass

func json_load(path):
	var file = File.new()
	file.open(path, File.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json)
	var value = json_result.result
	file.close()
	return value

func json_save(data,path):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(JSON.print(data,"\n"))
	file.close()
