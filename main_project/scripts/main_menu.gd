extends Control


# Declare member variables here. Examples:
var quotePath = "res://texts/mainMenu.json"
var currentLang = Main.currentLang;

# Параметры для загрузки локали
func _ready():
	# Загрузка текста кнопок в необходимой локали
	$menuContainer/VBoxContainer/newGameButton/Label.text = Main.json_load(quotePath)[currentLang]["newGame"]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_newGameButton_pressed():
	print('Button pressed!')
	get_tree().change_scene("res://testing scene.tscn")
	pass # Replace with function body.
