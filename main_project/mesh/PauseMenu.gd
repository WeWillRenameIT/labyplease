extends Control

func _ready():
	print("Pause menu")
	
func _input(event):
	if event.is_action_pressed("pause"):
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
