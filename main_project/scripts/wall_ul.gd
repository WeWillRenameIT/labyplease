extends Node2D

var fixed = false

func _ready():
	randomize()
	if !fixed and blink(3) == 0:
		yield(get_tree().create_timer(randi()%3 + 4),"timeout")
		$noise.play()
		$lustra_1/light.playing = true
		yield(get_tree().create_timer(randi()%3 + 1),"timeout")
		$lustra_1/light.playing = false
		$lustra_1/light.frame = 0
		$noise.stop()
	elif !fixed and blink(3) == 1:
		yield(get_tree().create_timer(randi()%3 + 4),"timeout")
		$noise.play()
		$lustra_2/light.playing = true
		yield(get_tree().create_timer(randi()%3 + 1),"timeout")
		$lustra_2/light.playing = false
		$lustra_2/light.frame = 0
		$noise.stop()
	elif !fixed and blink(3) == 2:
		yield(get_tree().create_timer(randi()%3 + 4),"timeout")
		$noise.play()
		$lustra_3/light.playing = true
		yield(get_tree().create_timer(randi()%3 + 1),"timeout")
		$lustra_3/light.playing = false
		$lustra_3/light.frame = 0
		$noise.stop()
	
	_ready()


func blink(num):
	randomize()
	return randi()%num



func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT and !$wall_dc.wait:
			get_parent().new_student(get_parent().level)
			#$wall_dc.new_student()
