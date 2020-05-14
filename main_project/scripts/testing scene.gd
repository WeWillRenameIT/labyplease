extends Node2D

var money = 0
var bank = 0 #SAVE
var right = 0 
var global_right = 0 #SAVE
var wrong = 0
var global_wrong = 0 #SAVE
var very_wrong = 0
var global_students = 0 #SAVE
var students = 0
var new = false
var children = 0
var open=false
var level = 3  #1- только отчет, 2- отч + флешка, 3 - всё. По сути это система уровней SAVE

func _ready():
	new_student(level)
	yield(get_tree().create_timer(2),"timeout")
	$room/dialog_box.visible = true
	$room/dialog_box/lbl_dialog.text = 'Oh hello there'
	yield(get_tree().create_timer(randi()%2),"timeout")
	$room/Next.visible = true
	$room/Leave.visible = true
	$room/dialog_box.visible = false
	randomize()

func _process(delta):
	if $computer/clocks.end:
		$room/wall_up_left/wall_dc/open_anim.visible = false
		$room/wall_up_left/wall_dc/queue/tolpa.stop()
		$room/wall_up_left/wall_dc/queue.visible = false
		if $players_stuff.get_child_count() !=0 :
			for child in $players_stuff.get_children():
				$players_stuff.remove_child(child)
		set_process(false)
		yield(get_tree().create_timer(3),"timeout")
		end()
	var wait = $room/wall_up_left/wall_dc.wait

func end():
	global_students += students
	global_right += right
	global_wrong += wrong
	global_wrong += very_wrong
	money = (right-wrong-10*very_wrong)*100
	if money < 0:
		money = 0
	bank+=money
	bank-=1000*very_wrong
	if bank<0:
		bank = 0
	$computer/background/shop.visible=true
	$computer/background/shop.play()
	$Camera2D.current=false
	$end_cam.current=true
	$computer/background/question.visible=false
	$computer/background/grayblock.visible = true
	$computer/background/grayblock/Label.text = "Students: " + String(students) + "\n Right: " +String(right) +"\n Wrong: " + String(wrong) 
	$computer/background/grayblock/Label.text += "\n money: " +String(money) +"p."
	if very_wrong >=0: $computer/background/grayblock/Label.text += "\n Fine:" + String(1000*very_wrong)
	$computer/background/grayblock/Label.text += "\n Bank: " +String(bank) +"p."

func noend():
	$Camera2D.current=true
	$end_cam.current=false
	$computer/background/shop.visible=false
	$computer/background/shop.stop()
	$computer/background/question.visible=true
	$computer/background/grayblock.visible = false
	for child in $players_stuff.get_children():
		$players_stuff.remove_child(child)
	new_student(level)

func new_student(num): #1- только отчет, 2- отч + флешка, 3 - всё
	student_leave(num)
	var otchet = preload("res://mesh/otchet.tscn").instance()
	var studak = preload("res://mesh/studak.tscn").instance()
	var fm = preload("res://mesh/fm_1.tscn").instance()
	for child in $players_stuff.get_children():
		$players_stuff.remove_child(child)
	var spawn1 = $spawn1.transform.get_origin()
	var spawn2 = $spawn2.transform.get_origin()
	var spawn3 = $spawn3.transform.get_origin()
	yield(get_tree().create_timer(1.5),"timeout")
	$room/student.visible = true
	$room/student.generate()
	if num >=1:
		$players_stuff.add_child(otchet)
		$players_stuff/otchet.new_position(spawn1)
	if num >=2:
		$players_stuff.add_child(fm)
		$players_stuff/fm_1.new_position(spawn3)
	if num == 3:
		$players_stuff.add_child(studak)
		$players_stuff/studak.new_position(spawn2)
	children = $players_stuff.get_child_count()
	print("new student")
	print(children)
	print("right: "+ String(right))
	print("wrong: "+ String(wrong))
	print("Very wrong: "+ String(very_wrong))

func student_leave(num):
	if $room/wall_up_left/wall_dc.wait:
		return
	if $computer.listing:
		return
	if num>3:
		num = 3
	elif num<1:
		num=1
	var super
	$room/wall_up_left/wall_dc.new_student()
	if $players_stuff.get_child_count() !=0 :
		students+=1
		if $players_stuff.get_child_count() == 1: #Изначально у игрока будет только отчет, на сл уровне добавим флешку, потом студак
			super =  $players_stuff/otchet.test()
		elif $players_stuff.get_child_count() == 2:
			super =  $players_stuff/otchet.test() and $players_stuff/fm_1.test()
		else:
			super =  $players_stuff/otchet.test() and $players_stuff/studak.fio() and $players_stuff/fm_1.test()
		if $players_stuff/otchet.approved():
			print("approved")
			if super:
				right+=1
			else:
				wrong+=1
		else:
			print("NOT approved")
			if super:
				if $players_stuff.get_child_count() >= 2:
					if !$players_stuff/fm_1.virus:
						very_wrong+=1
					else:
						wrong+=1
				else:
					wrong+=1
			else:
				right+=1
	$room/student.visible = false

func fio():
	if $players_stuff.get_child_count() == 3:
		return $players_stuff/studak.fio()
	else:
		return true

func children():
	return children
func new():
	return new
func open():
	if $players_stuff.get_child_count() == 3:
		return $players_stuff/studak.open
func set_bank(num):
	bank=num

func _on_background_music_ready():
	var audio_files = ["res://sounds/gameplay1.ogg", "res://sounds/gameplay2.ogg", "res://sounds/gameplay3.ogg"]
	var nextsong = randi()%3
	var new_audio_file = audio_files[nextsong]
	if File.new().file_exists(new_audio_file):
		var music = load(new_audio_file)
		music.set_loop(false)
		$background_music.stream = music
		$background_music.play()

func _on_background_music_finished():
	var audio_files = ["res://sounds/gameplay1.ogg", "res://sounds/gameplay2.ogg", "res://sounds/gameplay3.ogg"]
	var nextsong = randi()%2
	var new_audio_file
	if $background_music.stream.resource_path == audio_files[0]:
		if nextsong == 0:
			new_audio_file = audio_files[1]
		else:
			new_audio_file = audio_files[2]
	elif $background_music.stream.resource_path == audio_files[1]:
		if nextsong == 0:
			new_audio_file = audio_files[0]
		else:
			new_audio_file = audio_files[2]
	else:
		if nextsong == 0:
			new_audio_file = audio_files[0]
		else:
			new_audio_file = audio_files[1]
	
	if File.new().file_exists(new_audio_file):
		var music = load(new_audio_file)
		music.set_loop(false)
		$background_music.stream = music
		$background_music.play()
