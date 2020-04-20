extends Control


# Declare member variables here. Examples:
var quotePath = "res://texts/mainMenu.json"
var currentLang = Main.currentLang;

# Параметры для загрузки локали
func _ready():
	# Загрузка текста кнопок в необходимой локали
	$menuContainer/newGameButton/Label.text = Main.json_load(quotePath)[currentLang]["newGame"]
	$menuContainer/loadGameButton/Label.text = Main.json_load(quotePath)[currentLang]["loadGame"]
	$menuContainer/quitButton/Label.text = Main.json_load(quotePath)[currentLang]["quit"]
	pass # Replace with function body.


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
	var fileToSave = Main.json_load("res://options/options.json")
	fileToSave["language"] = Main.currentLang
	Main.json_save(fileToSave, "res://options/options.json")
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_loadGameButton_pressed():
	# TODO - загрузка сохранения
	pass # Replace with function body.


func _on_quitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.
