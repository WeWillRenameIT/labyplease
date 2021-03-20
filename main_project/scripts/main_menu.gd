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
	
	# Создать папку для сохранений, если её нет (важно для Android версии)
	if (!Directory.new().dir_exists("user://savedata")):
		Directory.new().make_dir("user://savedata/")
	
	# Загрузить локаль
	loadLocale()
	
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
	
	# Наполнение списка профилей (проходим по папке с сейвами, читаем файлы
	var profileList = $profileSelect/VBoxContainer/ProfileList
	var saveFileToAdd = saveDataDirectory.get_next()
	while saveFileToAdd != '':
		# TODO: Если JSON не парсентся, то откинуть файл
		if (Main.json_load(saveDataDirectoryString + saveFileToAdd) != null):
			var name = Main.json_load(saveDataDirectoryString + saveFileToAdd)["name"]
			if (name != null):
				profileList.add_item(name, null, true);
				# В метаданных сохраняем имя файла с сохранением
				profileList.set_item_metadata(profileList.get_item_count() - 1, saveDataDirectoryString + saveFileToAdd)
		saveFileToAdd = saveDataDirectory.get_next()
	
	if (profileList.get_item_count() > 0):
		# TODO: в options сохранить последний файл, если он ещё существует, выбрать его
		# иначе idx 0 как тут
		profileList.select(0)
		# Обработать, будто мы выбрали этот профиль
		_on_ProfileList_item_selected(0)
	else:
		# TODO: заблокировать кнопки новой игры и загрузки, пока не будет создан профиль?
		# временный фикс - создаётся сейв Player))
		profileList.add_item("Player", null, true);
		Main.newSaveFile("Player")
		profileList.select(0)
		# Обработать, будто мы выбрали этот профиль
		_on_ProfileList_item_selected(0)
	

func loadLocale():
	# Загрузка текста кнопок в необходимой локали
	$menuContainer/newGameButton.text = Main.json_load(localeFilePath)[currentLang]["newGame"]
	$menuContainer/loadGameButton.text = Main.json_load(localeFilePath)[currentLang]["loadGame"]
	$menuContainer/quitButton.text = Main.json_load(localeFilePath)[currentLang]["quit"]
	$Tutorial/Label.text = Main.json_load(localeFilePath)[currentLang]["tutorial"]
	$Tutorial2/Label.text = Main.json_load(localeFilePath)[currentLang]["tutorial2"]

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
	
	currentLang = Main.currentLang
	var fileToSave
	
	if File.new().file_exists(optionsFile):
		fileToSave = Main.json_load(optionsFile)
	else:
		Directory.new().copy("res://options/options.json", optionsFile)
		fileToSave = Main.json_load(optionsFile)
	
	fileToSave["language"] = Main.currentLang
	Main.json_save(fileToSave, optionsFile)
	#_ready()
	loadLocale()


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
	Main.newSaveFile(name)

# Выбор определённого профиля
func _on_ProfileList_item_selected(index):
	var saveName = $profileSelect/VBoxContainer/ProfileList.get_item_metadata(index)
	Main.loadSaveData(saveName)


func _on_ShowProfileSelectBtn_pressed():
	$profileSelect.visible = !$profileSelect.visible
