extends PopupMenu

func _on_Volume_value_changed(value):
	$Volume/ProgressBar.value = value
	var musicPlayer = get_tree().get_root().find_node("Music", true, false)
	musicPlayer.set_volume_db(linear2db(value))
	Main.currentVolume = value
	#Надо теперь сохранить значение громкости
	var data = Main.json_load("user://options.json")
	data["volume"] = value
	Main.json_save(data,"user://options.json")
	pass # Replace with function body.


func _on_Back_pressed():
	hide()
	pass # Replace with function body.


func _on_Options_Container_about_to_show():
	$Volume/ProgressBar.value = Main.json_load("user://options.json")["volume"]
	$Volume.value = Main.json_load("user://options.json")["volume"]
	var localeData = Main.json_load("res://texts/options.json")
	$OptionsLabel.text = localeData[Main.currentLang]["label"]
	$Volume/VolumeLabel.text = localeData[Main.currentLang]["volume"]
	$Back.text = localeData[Main.currentLang]["back"]
	pass # Replace with function body.
