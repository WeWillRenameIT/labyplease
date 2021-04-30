extends Node2D

func _ready():
	$Music.set_volume_db(linear2db(Main.currentVolume))
	pass # Replace with function body.

#func _process(delta):
#	pass


func _on_SkipButton_pressed():
	get_tree().change_scene("res://testing scene.tscn")
	pass # Replace with function body.


func _on_CutsceneAnimation_animation_finished(anim_name):
	get_tree().change_scene("res://testing scene.tscn")
	pass # Replace with function body.
