extends Node
# Это глобальный скрипт, он доступен в любой сцене в любое время.
# В него помещаются какие-то глобальные переменные, для простоты обращения к ним
# Также записываются глобальные функции, чтобы можно было использовать их в любом скрипте
# Постоянно их не объявляя в скрипте.
# Обращение к этому скрипту осуществляется через имя этого скрипта в Автозагрузке проекта,
# Т.е. Main
# Файловая система godot показывает только встроенные ресурсы! Файлы .json такими не считаются,
# Поэтому их не видно в файловой системе, если открыть папку options/texts в проводнике, можно будет увидеть
# json файлы

var currentLevel;
var currentLang; # Язык, который используется в данный момент.

# JSON-объект с данными сохранения, до загрузки пустой
var saveData = null

#var saveData = {
#	"name": "Player",
#	"currentLevel": 1,
#	"bank": 0,
#	"global_right": 0,
#	"global_wrong": 0,
#	"global_students": 0,
#	"level": 3,
#	"boot": false,
#	"test_s": false,
#	"vir": false,
#	"check": false,
#	"ports": 1
#}

func json_load(path): # Импрот данных из json файла, path - путь до json файла
	var file = File.new()
	file.open(path, File.READ)
	var json = file.get_as_text()
	var json_result = JSON.parse(json)
	var value = json_result.result
	file.close()
	return value

# Экспорт данных в json файл, путь до кортоого в переменной path
# В переменную data нужно записать весь json файл, заменив нужную информацию или вписав новую
# Таким образом json_load() и json_save() неразрывно связаны

func json_save(data,path): 
	var file = File.new()  
	file.open(path, File.WRITE)
	file.store_string(JSON.print(data,"\n"))
	file.close()
	
