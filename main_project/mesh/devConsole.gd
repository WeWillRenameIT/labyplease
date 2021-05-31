extends Control

signal consoleDestroyed # в принципе не нужно из-за глобальной переменной console_count
						# но если очень интересен механизм работы то в main_menu он описан

# *? можно добавить буффер, чтобы запоминать предыдущие команды

func _ready():
	$LineEdit.max_length = 30

func _on_TextureButton_pressed():
	queue_free()
	Main.consoles_count -= 1
	emit_signal("consoleDestroyed")

func _input(event):
	if(event.is_action_pressed("enter_console")):
		if($LineEdit.text == 'sv_cheats(1)'):
			$TextEdit.text = 'Тут так не принято'
		if(get_parent().name == 'level_test'):
			if($LineEdit.text =='next_level'):
				get_parent().end()
			else:
				$TextEdit.text = 'wrong command'
		$LineEdit.text = ''
		#print('Всего строк ',$TextEdit.get_line_count())
		#print('Текующая - ',$TextEdit.cursor_get_line(), ' её текст: ', $TextEdit.text[$TextEdit.cursor_get_line()])
		pass


func _on_TextEdit_breakpoint_toggled(row):
	print('breakpoint and ', row)
	pass # Replace with function body.
