extends Control


# Declare member variables here. Examples:
var localeFilePath = "res://texts/mainMenu.json"
var currentLang
var optionsFile

# Параметры для загрузки локали
func _ready():
	optionsFile = "user://options.json"
	if File.new().file_exists(optionsFile):
		Main.currentLang = Main.json_load(optionsFile)["language"]
		currentLang = Main.currentLang
	else:
		Directory.new().copy("res://options/options.json", optionsFile)
		Main.currentLang = Main.json_load(optionsFile)["language"]
		currentLang = Main.currentLang
	
	# Загрузка текста кнопок в необходимой локали
	$menuContainer/newGameButton/Label.text = Main.json_load(localeFilePath)[currentLang]["newGame"]
	$menuContainer/loadGameButton/Label.text = Main.json_load(localeFilePath)[currentLang]["loadGame"]
	$menuContainer/quitButton/Label.text = Main.json_load(localeFilePath)[currentLang]["quit"]
	
	# Запустить анимацию облаков
	$Art/Clouds.material.set_shader_param("scroll_speed", 0.025)
	
	# Включить музыку
	if (!$Music.is_playing()):
		$Music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_newGameButton_pressed():
	get_tree().change_scene("res://testing scene.tscn")
	pass # Replace with function body.

func _on_languageToggleBtn_pressed():
	if (Main.currentLang == "English"):
		Main.currentLang = "Russian"
	else:
		Main.currentLang = "English"
	var fileToSave
	if File.new().file_exists(optionsFile):
		fileToSave = Main.json_load(optionsFile)
	else:
		Directory.new().copy("res://options/options.json", optionsFile)
		fileToSave = Main.json_load(optionsFile)
	fileToSave["language"] = Main.currentLang
	Main.json_save(fileToSave, optionsFile)
	_ready()


func _on_loadGameButton_pressed():
	# TODO - загрузка сохранения
	pass # Replace with function body.


func _on_quitButton_pressed():
	get_tree().quit()
