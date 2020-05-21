extends Node2D

var canStamp = false
var test
var testArea
func _ready():
	pass # Replace with function body.

func _on_stamp_1_input_event(viewport, event, shape_idx):
	get_tree().set_input_as_handled()
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			#if canStamp ==  true and test.get_parent().cp == 0:
			if canStamp ==  true:
				#print("bruh")
				var obj_scene = preload("res://mesh/approved.tscn")
				var obj = obj_scene.instance()
				
				#obj.region_enabled = true
				#obj.set_region_rect(Rect2(Vector2(0,0),)) 
				#print(testArea.get_overlapping_areas())
				#print(obj.get_region_rect()) 
				obj.set_position(get_global_position()-test.get_global_position())
				obj.position.y += 9
				test.add_child(obj)
				test.get_parent().approved = true
				#print("disance:" , testArea.position - obj.position)
			

	pass

#хз, щас помацаем штампы

func _on_stamp_1_area_shape_entered(area_id, area, area_shape, self_shape):
	#print("area = ",area)
	#print("area_id = ",area_id)
	#print("area_shape = ", area_shape)
	#print("self_shape = " ,self_shape)
	"""bruh = area.add_child(stamp_appr)
	var test = area.get_parent()
	print(bruh , " " , test.bruh)"""
	test = area.get_parent()
	#obj.set_position(get_position_in_parent())
	#obj.set_position(get_local_mouse_position())
#	test.add_child(obj)
	#test.obj.scale = Vector2(1.25,1.25)
	#add_child(area)
	#var obj = add_child(area.obj_scene.instance())
	#print(obj)
	canStamp = true
	testArea = area
	pass 


func _on_stamp_1_area_shape_exited(area_id, area, area_shape, self_shape):
	#canStamp = false
	#print("НЕ Ставь печать!")
	pass # Replace with function body.


func _on_stamp_1_area_exited(area):
	canStamp = false
	pass # Replace with function body.
