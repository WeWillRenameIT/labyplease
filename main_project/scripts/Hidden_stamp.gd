extends Node2D

func _on_strelo4ka_pressed():
	$show.visible = true
	$strelo4ka.visible = false
	$strelo4ka.disabled = true
	#print($strelo4ka.disabled) # debug
	$show/strelo4ka2.disabled = true
	yield(get_tree().create_timer(0,5),"timeout")
	$show/strelo4ka2.disabled = false;

func _on_strelo4ka2_pressed():
	$show.visible = false
	$strelo4ka.visible = true
	yield(get_tree().create_timer(0,5),"timeout")
	$strelo4ka.disabled = false;
