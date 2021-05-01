extends Control


signal consoleDestroyed

var currentLine = 0

func _on_TextureButton_pressed():
	queue_free()
	emit_signal("consoleDestroyed")

func _input(event):
	if(event.is_action_pressed("enter_console")):
		print($TextEdit.get_line_count())
		pass
