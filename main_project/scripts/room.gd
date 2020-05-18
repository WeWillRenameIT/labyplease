extends Node2D

# Переменные локали
var studentDialogueGreetings = ["","","",""]
var studentDialoguePositive = ["","","",""]
var studentDialogueNegative = ["","","",""]
# Когда уровень начинается, приглашается первый студент
# Кричать "следующий" в этом случае не надо
# Поэтому эта переменная поменяется на true после того, как мы отпустим первого студента
var showNextDialogue = false 

func _ready():
	randomize()
	# Параметры для загрузки локали
	var quotePath = "res://texts/room.json"
	var currentLang = Main.currentLang;
	# Загрузка фраз в текущей локали
	studentDialogueGreetings[0] = Main.json_load(quotePath)[currentLang]["studentDialogueGreeting1"]
	studentDialogueGreetings[1] = Main.json_load(quotePath)[currentLang]["studentDialogueGreeting2"]
	studentDialogueGreetings[2] = Main.json_load(quotePath)[currentLang]["studentDialogueGreeting3"]
	studentDialogueGreetings[3] = Main.json_load(quotePath)[currentLang]["studentDialogueGreeting4"]
	studentDialoguePositive[0] = Main.json_load(quotePath)[currentLang]["studentDialoguePositive1"]
	studentDialoguePositive[1] = Main.json_load(quotePath)[currentLang]["studentDialoguePositive2"]
	studentDialoguePositive[2] = Main.json_load(quotePath)[currentLang]["studentDialoguePositive3"]
	studentDialoguePositive[3] = Main.json_load(quotePath)[currentLang]["studentDialoguePositive4"]
	studentDialogueNegative[0] = Main.json_load(quotePath)[currentLang]["studentDialogueNegative1"]
	studentDialogueNegative[1] = Main.json_load(quotePath)[currentLang]["studentDialogueNegative2"]
	studentDialogueNegative[2] = Main.json_load(quotePath)[currentLang]["studentDialogueNegative3"]
	studentDialogueNegative[3] = Main.json_load(quotePath)[currentLang]["studentDialogueNegative4"]
	$Next/lbl_next.text = Main.json_load(quotePath)[currentLang]["nextStudent"]
	$Leave/lbl_leave.text = Main.json_load(quotePath)[currentLang]["dismissStudent"]

func _on_Next_pressed():
	$Next.visible = false
	$Leave.visible = false
	"""
	if $student.visible:
		if get_parent().getApproved():
			$dialog_box/lbl_dialog.text = studentDialoguePositive[randi()%4]
		else:
			$dialog_box/lbl_dialog.text = studentDialogueNegative[randi()%4]
		$dialog_box.visible = true
		yield(get_tree().create_timer(2),"timeout")
		$dialog_box.visible = false
	"""
	if (showNextDialogue):
		$wall_up_left/dialog_box.visible = true
	get_parent().new_student(get_parent().level)
	yield(get_tree().create_timer(1),"timeout")
	$wall_up_left/dialog_box.visible = false
	yield(get_tree().create_timer(1),"timeout")
	$dialog_box.visible = true
	$dialog_box/lbl_dialog.text = studentDialogueGreetings[randi()%4]
	yield(get_tree().create_timer(2),"timeout")
	#$Next.visible = true
	$Leave.visible = true
	$dialog_box.visible = false


func _on_Leave_pressed():
	$wall_up_left/wall_dc/open_anim.frame = 1
	$Leave.visible = false
	if $student.visible:
		if get_parent().getApproved():
			$dialog_box/lbl_dialog.text = studentDialoguePositive[randi()%4]
		else:
			$dialog_box/lbl_dialog.text = studentDialogueNegative[randi()%4]
		$dialog_box.visible = true
		yield(get_tree().create_timer(2),"timeout")
		$dialog_box.visible = false
	get_parent().student_leave(get_parent().level)
	showNextDialogue = true
	$Next.visible = true
	$wall_up_left/wall_dc/open_anim.frame = 0
	if get_parent().end_time:
		set_process(false)
		get_parent().end()
