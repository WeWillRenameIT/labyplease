extends Node2D

func _ready():
	pass # Replace with function body.


func _on_Next_pressed():
	$Next.visible = false
	$Leave.visible = false
	if $student.visible:
		$dialog_box.visible = true
		$dialog_box/lbl_dialog.text = 'Goodbye'
		yield(get_tree().create_timer(2),"timeout")
		$dialog_box.visible = false
	get_parent().new_student(get_parent().level)
	yield(get_tree().create_timer(2),"timeout")
	$dialog_box.visible = true
	$dialog_box/lbl_dialog.text = 'Oh hello there'
	yield(get_tree().create_timer(randi()%2),"timeout")
	$Next.visible = true
	$Leave.visible = true
	$dialog_box.visible = false


func _on_Leave_pressed():
	$Leave.visible = false
	if $student.visible:
		$dialog_box.visible = true
		$dialog_box/lbl_dialog.text = 'Oh ok then...'
		yield(get_tree().create_timer(2),"timeout")
		$dialog_box.visible = false
	get_parent().student_leave(get_parent().level)
	$Next.visible = true
