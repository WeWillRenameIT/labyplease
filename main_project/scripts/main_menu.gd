extends Control


# Declare member variables here. Examples:
var localeFilePath = "res://texts/mainMenu.json"
var saveDataDirectoryString = "user://savedata/"
var currentLang
var optionsFile

func _ready():
	# Загрузить настройки
	optionsFile = "user://options.json"
	if File.new().file_exists(optionsFile):
		Main.currentLang = Main.json_load(optionsFile)["language"]
		currentLang = Main.currentLang
		#Main.currentVolume = Main.json_load(optionsFile)["volume"] #problem, need fix!
	else:
		Directory.new().copy("res://options/templates/options.json", optionsFile)
		Main.currentLang = Main.json_load(optionsFile)["language"]
		currentLang = Main.currentLang
		Main.currentVolume = Main.json_load(optionsFile)["volume"]
	
	# Создать папку для сохранений, если её нет (важно для Android версии)
	if (!Directory.new().dir_exists("user://savedata")):
		Directory.new().make_dir("user://savedata/")
	
	# Загрузить локаль
	loadLocale()
	
	# Заблокировать кнопки, пока не загрузится сейв
	lockButtons()
	
	# Запустить анимацию облаков
	#$Art/Clouds.material.set_shader_param("scroll_speed", 0.025)
	
	# Включить музыку
	if (!$Music.is_playing()):
		$Music.play()
		$Music.set_volume_db(linear2db(Main.currentVolume))
	
	# Загрузка профилей
	var saveDataDirectory = Directory.new()
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
		$profileSelect.visible = true
		$CreateProfileDialog.popup()
	

func loadLocale():
	# Загрузка текста кнопок в необходимой локали
	var localeData = Main.json_load(localeFilePath)[currentLang]
	$menuContainer/newGameButton.text = localeData["newGame"]
	$menuContainer/loadGameButton.text = localeData["loadGame"]
	$menuContainer/quitButton.text = localeData["quit"]
	
	$Tutorial/Label.text = localeData["tutorial"]
	$Tutorial2/Label.text = localeData["tutorial2"]
	
	$ShowProfileSelectBtn.text = localeData["profiles"]
	$profileSelect/VBoxContainer/Label.text = localeData["profiles"]
	$profileSelect/VBoxContainer/NewProfileBtn.text = localeData["newProfile"]
	$profileSelect/VBoxContainer/DeleteProfileBtn.text = localeData["deleteProfile"]
	
	$CreateProfileDialog.window_title = localeData["createProfileDialogWindowTitle"]
	$CreateProfileDialog.get_ok().text = localeData["createProfileDialogOk"]
	$CreateProfileDialog.get_cancel().text = localeData["dialogCancel"]
	
	$DeleteProfileDialog.window_title = localeData["deleteProfileDialogWindowTitle"]
	$DeleteProfileDialog.dialog_text = localeData["deleteProfileDialogText"]
	$DeleteProfileDialog.get_ok().text = localeData["deleteProfileDialogOk"]
	$DeleteProfileDialog.get_cancel().text = localeData["dialogCancel"]
	
	$menuContainer/options.text = localeData["options"]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Блокирует кнопки "Новая игра" и "Загрузить игру", а так же "Удалить профиль"
# Когда сейв не выбран они должны быть заблокированы
func lockButtons():
	$menuContainer/newGameButton.disabled = true
	$menuContainer/loadGameButton.disabled = true
	$profileSelect/VBoxContainer/DeleteProfileBtn.disabled = true

# Разблокирует кнопки "Новая игра" и "Загрузить игру", а так же "Удалить профиль"
func unlockButtons():
	$menuContainer/newGameButton.disabled = false
	$profileSelect/VBoxContainer/DeleteProfileBtn.disabled = false
	if (!isBlankSaveData()):
		$menuContainer/loadGameButton.disabled = false
	else:
		$menuContainer/loadGameButton.disabled = true

# Проверяет, пустой ли сейв и разблокирует кнопку "Загрузить игру"
func isBlankSaveData():
	# TODO: Переписать
	# Берём два JSON, удаляем у них name и сравниваем
	var matches = 0
	for key in Main.saveData.keys():
		if key != "name" and Main.blankSaveData[key] == Main.saveData[key]:
			matches += 1
	#print(matches) # debug
	if matches == 11:
		return true
	else:
		return false

func _on_newGameButton_pressed():
	#Думаю эт бесполнезно (Doktan: 21.03.2021)
	# Да, это какой-то легаси (Kirieraito: 25.03.2021)
	#------------------------------------------
	#Main.currentLevel = 1;
	#var temp = Main.json_load("user://options.json")
	#temp['currentLevel'] = Main.currentLevel
	#Main.json_save(temp,"user://options.json")
	#-------------------------------------------
	Main.newGame()
	get_tree().change_scene("res://cutscenes/Intro.tscn")
	#get_tree().change_scene("res://testing scene.tscn")
	
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
	get_tree().change_scene("res://testing scene.tscn")

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
	var name = $CreateProfileDialog/NameInput.text
	if (name.length() > 0 && !Main.profileExists(name)):
		var saveFile = Main.newSaveFile(name)
		var profileList = $profileSelect/VBoxContainer/ProfileList
		profileList.add_item(name, null, true)
		profileList.set_item_metadata(profileList.get_item_count() - 1, saveFile)
		$CreateProfileDialog/NameInput.text = ""
		$profileSelect/VBoxContainer/ProfileList.select(profileList.get_item_count() - 1)
		_on_ProfileList_item_selected(profileList.get_item_count() - 1)
	else:
		$CreateProfileDialog.popup()

# Выбор определённого профиля
func _on_ProfileList_item_selected(index):
	var saveName = $profileSelect/VBoxContainer/ProfileList.get_item_metadata(index)
	Main.loadSaveData(saveName)
	unlockButtons()

func _on_ShowProfileSelectBtn_pressed():
	$profileSelect.visible = !$profileSelect.visible

func _on_NewProfileBtn_pressed():
	$CreateProfileDialog.popup();
	$CreateProfileDialog/NameInput.grab_focus()


func _on_DeleteProfileBtn_pressed():
	$DeleteProfileDialog.popup();


func _on_DeleteProfileDialog_confirmed():
	var saveFileToDelete = Main.saveFile
	Main.deleteSaveFile()
	for i in ($profileSelect/VBoxContainer/ProfileList.get_item_count()):
		if ($profileSelect/VBoxContainer/ProfileList.get_item_metadata(i) == saveFileToDelete):
			$profileSelect/VBoxContainer/ProfileList.remove_item(i)
	lockButtons()
	
	# Загрузить другой сейв, если остался
	if ($profileSelect/VBoxContainer/ProfileList.get_item_count() > 0):
		$profileSelect/VBoxContainer/ProfileList.select(0)
		_on_ProfileList_item_selected(0)


func _on_options_pressed():
	get_node("Options Container").popup()
	pass # Replace with function body.

var consoles_count = 0
func _input(event):
	if(event.is_action_pressed("console") and consoles_count == 0):
		var node = load("res://mesh/devConsole.tscn")
		var console_instance = node.instance()
		console_instance.set_name("console")
		add_child(console_instance)
		consoles_count+=1
		console_instance.set_position(Vector2(0,465))
		console_instance.connect("consoleDestroyed",self,"OnConsoleDestroyed")
		var textEdit = console_instance.get_node("TextEdit")
		

func OnConsoleDestroyed():
	consoles_count -= 1

