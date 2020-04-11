extends Node2D

var show = false
var take = false

func _process(delta):
	if $lineyka.visible:
		$locker/lock.frame = 1
	else:
		$locker/lock.frame = 0

func _on_rul_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				take = true
				$locker/lock.frame = 1
				$lineyka.visible = true
				$lineyka.new_position(get_parent().transform.get_origin() - Vector2(265,-43.9))


func _on_strelka_a2_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				if !show:
					show = true
					$strelka_a.visible = false
					if take:
						$locker/lock.frame = 1
						$locker.visible = true
					else:
						$locker/lock.frame = 0
						$locker.visible = true
				else:
					show = false
					$strelka_a.visible = true
					$locker.visible = false# Replace with function body.


func _on_strelka_a_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				if !show:
					show = true
					$strelka_a.visible = false
					$locker.visible = true
				else:
					show = false
					$strelka_a.visible = true
					$locker.visible = false# Replace with function body.
