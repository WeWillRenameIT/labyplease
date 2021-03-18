extends Control


# Declare member variables here. Examples:
var localeFilePath = "res://texts/mainMenu.json"
var currentLang
var optionsFile

func _ready():
	# Загрузить настройки
	optionsFile = "user://options.json"
	if File.new().file_exists(optionsFile):
		Main.currentLang = Main.json_load(optionsFile)["language"]
		currentLang = Main.currentLang
	else:
		Directory.new().copy("res://options/templates/options.json", optionsFile)
		Main.currentLang = Main.json_load(optionsFile)["language"]
		currentLang = Main.currentLang
		
	# Загрузить сохранение (TODO: отдельные профили с именами)
	var saveFile = "user://savedata/Player.save"
	if File.new().file_exists(saveFile):
		Main.saveData = Main.json_load(saveFile)
	else:
		Directory.new().make_dir("user://savedata")
		Directory.new().copy("res://options/templates/Player.save", saveFile)	
		Main.saveData = Main.json_load(saveFile)
	
	# Загрузка текста кнопок в необходимой локали
	$menuContainer/newGameButton/Label.text = Main.json_load(localeFilePath)[currentLang]["newGame"]
	$menuContainer/loadGameButton/Label.text = Main.json_load(localeFilePath)[currentLang]["loadGame"]
	$menuContainer/quitButton/Label.text = Main.json_load(localeFilePath)[currentLang]["quit"]
	$Tutorial/Label.text = Main.json_load(localeFilePath)[currentLang]["tutorial"]
	$Tutorial2/Label.text = Main.json_load(localeFilePath)[currentLang]["tutorial2"]
	
	# Запустить анимацию облаков
	$Art/Clouds.material.set_shader_param("scroll_speed", 0.025)
	
	# Включить музыку
	if (!$Music.is_playing()):
		$Music.play()
	
	# Загрузка профилей
	var saveDataDirectoryString = "user://savedata/"
	var saveDataDirectory =  Directory.new()
	saveDataDirectory.open(saveDataDirectoryString)
	saveDataDirectory.list_dir_begin(true)
	
	var saveFileToAdd = saveDataDirectory.get_next()
	while saveFileToAdd != '':
		# TODO: Если JSON не парсентся, то откинуть файл
		print(saveFileToAdd)
		var name = Main.json_load(saveDataDirectoryString + saveFileToAdd)["name"]
		$profileSelect/VBoxContainer/ProfileList.add_item(name, null, true);
		saveFileToAdd = saveDataDirectory.get_next()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_newGameButton_pressed():
	Main.currentLevel = 1;
	var temp = Main.json_load("user://options.json")
	temp['currentLevel'] = Main.currentLevel
	Main.json_save(temp,"user://options.json")
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
	Main.currentLevel = Main.json_load("user://options.json")["currentLevel"]
	get_tree().change_scene("res://testing scene.tscn")
	# TODO - загрузка сохранения
	pass # Replace with function body.


func _on_quitButton_pressed():
	get_tree().quit()


func _on_TutorialButton_pressed():
	if ($Tutorial.visible == false && $Tutorial2.visible == false):
		$Tutorial.visible = true
	else:
		$Tutorial.visible = false
		$Tutorial2.visible = false


func _on_Button_pressed():
	$Tutorial.visible = false
	$Tutorial2.visible = true


func _on_Button2_pressed():
	$Tutorial2.visible = false
	$Tutorial.visible = true


func _on_CreateProfile_pressed():
	var name = $profileSelect/VBoxContainer/NameInput.text
	if (name.length() > 0):
		$profileSelect/VBoxContainer/ProfileList.add_item(name, null, true)
		$profileSelect/VBoxContainer/NameInput.text = ""
