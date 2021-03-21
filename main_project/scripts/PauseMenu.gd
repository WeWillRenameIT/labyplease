extends Control

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
	get_tree().quit()
	pass # Replace with function body.

func _on_Load_pressed():
	pass # Replace with function body.

func _on_Save_pressed():
	pass # Replace with function body.

func _on_GoToMainMenu_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://main menu/mainMenu.tscn")
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
