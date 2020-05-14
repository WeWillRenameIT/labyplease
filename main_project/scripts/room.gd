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
	$wall_up_left/dialog_box.visible = true
	get_parent().new_student(get_parent().level)
	yield(get_tree().create_timer(1),"timeout")
	$wall_up_left/dialog_box.visible = false
	yield(get_tree().create_timer(1),"timeout")
	$dialog_box.visible = true
	$dialog_box/lbl_dialog.text = 'Oh hello there'
	yield(get_tree().create_timer(2),"timeout")
	$Next.visible = true
	$Leave.visible = true
	$dialog_box.visible = false


func _on_Leave_pressed():
	$wall_up_left/wall_dc/open_anim.frame = 1
	$Leave.visible = false
	if $student.visible:
		$dialog_box.visible = true
		$dialog_box/lbl_dialog.text = 'Oh ok then...'
		yield(get_tree().create_timer(2),"timeout")
		$dialog_box.visible = false
	get_parent().student_leave(get_parent().level)
	$Next.visible = true
	$wall_up_left/wall_dc/open_anim.frame = 0
