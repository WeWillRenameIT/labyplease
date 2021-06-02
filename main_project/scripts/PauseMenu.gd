extends Control

# переменная, которая говорит, куда идти из меню паузы (main menu or exit)
var goTo = ''

func _ready():
	$OptionsBlock/Volume.value = Main.currentVolume
	# Параметры для загрузки локали
	var localeFilePath = "res://texts/pauseMenu.json"
	var currentLang = Main.currentLang;
	var localeJson = Main.json_load(localeFilePath)
	
	$PauseBlock/Label.text = localeJson[currentLang]["label"]
	$PauseBlock/QuitGameButton.text = localeJson[currentLang]["quitGameButton"]
	$PauseBlock/HBoxContainer/LoadButton.text = localeJson[currentLang]["loadButton"]
	$PauseBlock/HBoxContainer/SaveButton.text = localeJson[currentLang]["saveButton"]
	$PauseBlock/BackToMainMenuButton.text = localeJson[currentLang]["backToMainMenuButton"]
	$PauseBlock/ContinueButton.text = localeJson[currentLang]["continueButton"]
	$PauseBlock/OptionsButton.text = localeJson[currentLang]["optionsButton"]
	$OptionsBlock/OptionsLabel.text = localeJson[currentLang]["optionsButton"]
	$OptionsBlock/Volume/VolumeLabel.text = localeJson[currentLang]["volume"]
	$Dialog/Dialog_window/Decline.text = localeJson[currentLang]["decline"]
	$Dialog/Dialog_window/Confirm.text = localeJson[currentLang]["confirm"]
	$OptionsBlock/Fullscreen.text = Main.json_load("res://texts/options.json")[currentLang]["toggleFS"]
	print("Pause menu")
	
func _input(event):
	if event.is_action_pressed("pause"):
		if $OptionsBlock.visible == true:
			_on_Back_pressed()
		elif $PauseBlock.visible == true:
			get_tree().set_input_as_handled()
			get_tree().paused = false
			queue_free()

func _on_Exit_pressed():
	$Dialog.visible = true
	goTo = 'Exit'
	var localeFilePath = "res://texts/pauseMenu.json"
	var currentLang = Main.currentLang;
	var localeJson = Main.json_load(localeFilePath)
	$Dialog/Dialog_window/RichTextLabel.text = localeJson[currentLang]["exitText"]
	#$ConfirmationDialogExit.popup()
	#$ConfirmationDialogExit.set_scale(get_scale())
	#$ConfirmationDialogExit.set_position(Vector2(-88.176,-80))
	#$ConfirmationDialogExit.dialog_text = "Вы точно хотите выйти?"
	#$ConfirmationDialogExit.get_child(1).align = HALIGN_CENTER
	#$ConfirmationDialogExit.window_title = "Выход"
	#print($ConfirmationDialogExit.get_global_position())
	#print("bruh ", $ConfirmationDialogExit.get_position())
	#get_tree().quit()

	pass # Replace with function body.

func _on_Load_pressed():
	pass # Replace with function body.

func _on_Save_pressed():
	pass # Replace with function body.

func _on_GoToMainMenu_pressed():
	$Dialog.visible = true
	goTo = 'MainMenu'
	var localeFilePath = "res://texts/pauseMenu.json"
	var currentLang = Main.currentLang;
	var localeJson = Main.json_load(localeFilePath)
	$Dialog/Dialog_window/RichTextLabel.text = localeJson[currentLang]["mainMenuText"]
	#$ConfirmationDialogMainMenu.popup()
	#$ConfirmationDialogMainMenu.set_position(Vector2(-160.32,-80.2949))
	#$ConfirmationDialogMainMenu.set_scale(get_scale())
	pass # Replace with function body.
	
func _on_Continue_pressed():
	get_tree().paused = false
	queue_free()
	pass # Replace with function body.

func _on_Options_pressed():
	$PauseBlock.visible = false
	$OptionsBlock.visible = true
	pass # Replace with function body.


func _on_Back_pressed():
	$PauseBlock.visible = true
	$OptionsBlock.visible = false
	pass # Replace with function body.

func _on_Volume_value_changed(value):
	$OptionsBlock/Volume/ProgressBar.value = value
	var musicPlayer = get_tree().get_root().find_node("background_music", true, false)
	musicPlayer.set_volume_db(linear2db(value))
	Main.currentVolume = value
	#Надо теперь сохранить значение громкости
	var data = Main.json_load("user://options.json")
	data["volume"] = value
	Main.json_save(data,"user://options.json")
	pass # Replace with function body.


func _on_ConfirmationDialogExit_confirmed():
	get_tree().quit()
	pass # Replace with function body.


func _on_ConfirmationDialogMainMenu_confirmed():
	get_tree().paused = false
	get_tree().change_scene("res://main menu/mainMenu.tscn")
	pass # Replace with function body.


func _on_Confirm_pressed():
	
	if(goTo == 'MainMenu'):
		get_tree().paused = false
		get_tree().change_scene("res://main menu/mainMenu.tscn")
	else:
		get_tree().quit()
	pass # Replace with function body.


func _on_Decline_pressed():
	$Dialog.visible = false
	pass # Replace with function body.


func _on_Fullscreen_pressed():
	var data = Main.json_load("user://options.json")
	OS.window_fullscreen = !OS.window_fullscreen
	data["fullScreen"] = OS.window_fullscreen
	Main.json_save(data,"user://options.json")
	pass # Replace with function body.
