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

#var currentLevel; # Легаси какой-то. / (с) Вова
var currentLang; # Язык, который используется в данный момент.
var currentVolume = 1

# Данные сохранения, до загрузки пустые
var saveFile = null
var saveData = null

func newGame():
	if (saveData != null):
		var name = saveData.name
		saveData = blankSaveData
		saveData.name = name
		saveSaveData()

func loadSaveData(saveFileFullPath):
	saveFile = saveFileFullPath
	if (saveFile != null):
		saveData = json_load(saveFile)

func saveSaveData():
	json_save(saveData, saveFile)

func profileExists(profileName):
	var saveDataDirectory = Directory.new()
	saveDataDirectory.open("user://savedata/")
	saveDataDirectory.list_dir_begin(true)
	
	var nextSaveFile = saveDataDirectory.get_next()
	while nextSaveFile != '':
		# TODO: Если JSON не парсентся, то откинуть файл
		if (Main.json_load("user://savedata/" + nextSaveFile) != null):
			var name = Main.json_load("user://savedata/" + nextSaveFile)["name"]
			if (name == profileName):
				return true
		nextSaveFile = saveDataDirectory.get_next()
	return false

# Создаёт новый сейв для профиля с именем profileName, возвращает путь к файлу
func newSaveFile(profileName):
	if (saveFile != null && saveData != null):
		saveSaveData()
	saveData = blankSaveData
	saveData.name = profileName
	saveFile = "user://savedata/" + profileName + ".save"
	saveSaveData()
	return saveFile

func deleteSaveFile():
	if (saveFile != null && saveData != null):
		Directory.new().remove(saveFile)
		saveData = null
		saveFile = null

const blankSaveData = {
	"name": "Player",
	"currentLevel": 1,
	"bank": 0,
	"global_right": 0,
	"global_wrong": 0,
	"global_students": 0,
	"level": 3,
	"boot": false,
	"test_s": false,
	"vir": false,
	"check": false,
	"ports": 1
}

func _ready():
	currentLang = json_load("user://options.json")["language"]
	currentVolume = json_load("user://options.json")["volume"]
	pause_mode = Node.PAUSE_MODE_PROCESS

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

#данная функция не спавнит
func pause_game():
	var pause_menu = preload("res://mesh/PauseMenu.tscn")
	var instance = pause_menu.instance()
	return instance
	#add_child(instance)
	#instance.set_position(Vector2(-553.015,-304))
	#instance.set_scale(Vector2(0.503,0.557))
	get_tree().paused = true;
	
	pass
	

