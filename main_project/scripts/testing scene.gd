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
var level = 3  #1 - отч + флешка, 2 - добавляем вирусы 3 - добавляем студак. По сути это система уровней SAVE
var end_time
var optionsPath = "user://options.json"
var student = false

func _ready():
	# Загрузить данные из сохранения	
	print("Профиль: " + Main.saveData['name'])
	bank = Main.saveData['bank'] # Кол-во денег у игрока
	global_right = Main.saveData['global_right']
	global_wrong = Main.saveData['global_wrong']
	global_students = Main.saveData['global_students']
	level = Main.saveData['level']
	
	print("Current level: ", Main.saveData['level'])
	randomize()
	# Запустить первого студента
	$room._on_Next_pressed()
	"""new_student(level)
	yield(get_tree().create_timer(2),"timeout")
	$room/dialog_box.visible = true
	$room/dialog_box/lbl_dialog.text = 'Oh hello there'
	yield(get_tree().create_timer(2),"timeout")
	$room/Next.visible = true
	$room/Leave.visible = true
	$room/dialog_box.visible = false"""
	
	#Загружаем текущее значение громкости
	$background_music.set_volume_db(linear2db(Main.currentVolume))

func _input(event):
	if event.is_action_pressed("pause"):
		#Main.pause_game() #эт пока не работает, и, видимо, работать не будет
		#хз как сделать это из main скрипта, но ладно
		#--------------------------------------------------
		var pause_menu = preload("res://mesh/PauseMenu.tscn")
		var instance = pause_menu.instance()
		# получаем все камеры из группы cam
		var cams = get_tree().get_nodes_in_group("cam")
		var currentCam
		# проходимся по массиву камер, берем из них ту, которая сейчас
		# используется, т.е. current

		for cam in cams:
			if cam.is_current():
				currentCam = cam
		
		currentCam.add_child(instance)
		# zoom камеры == scale паузы
		instance.set_scale(currentCam.get_zoom())
		get_tree().paused = true;
		#--------------------------------------------------
	if(event.is_action_pressed("console")):
		if(Main.consoles_count == 0):
			var node = load("res://mesh/devConsole.tscn")
			var console_instance = node.instance()
			console_instance.set_name("console")
			add_child(console_instance)
			Main.consoles_count+=1
			console_instance.set_scale(Vector2(0.503,0.513))
			console_instance.set_position(Vector2(-322.074,64.256))
			console_instance.connect("consoleDestroyed",self,"OnConsoleDestroyed")
			var textEdit = console_instance.get_node("TextEdit")
		else:
			get_node('console')._on_TextureButton_pressed()

func _process(delta):
	#print(get_tree().is_input_handled())
	end_time = $computer/clocks.end
	if end_time:
		#$room/wall_up_left/wall_dc/open_anim.visible = false
		$room/wall_up_left/wall_dc/queue/tolpa.stop()
		$room/wall_up_left/wall_dc/queue.visible = false
		set_process(false)
		if student == false:
			end()
		#yield(get_tree().create_timer(3),"timeout")
		#end()
	if $computer/clocks.i >= 1065:
		$room/Next.visible = false
	var wait = $room/wall_up_left/wall_dc.wait

func end():
	if $players_stuff.get_child_count() !=0 :
		for child in $players_stuff.get_children():
			$players_stuff.remove_child(child)
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
	$computer/background/shop.visible = true
	$computer/background/shop.playing = true
	$computer/background/shop.play()
	
	comp_cam(true)
	
	if end_time:
		$computer/background/grayblock/repair_reader.disabled=true
		$computer/background/grayblock/repair_reader.visible=false
	$computer/background/question.visible = false
	$computer/background/grayblock.visible = true
	
	var quotePath = "res://texts/computer.json"
	var currentLang = Main.currentLang;
	var statsStudents = Main.json_load(quotePath)[currentLang]["statsStudents"]
	var statsCorrect = Main.json_load(quotePath)[currentLang]["statsCorrect"]
	var statsWrong = Main.json_load(quotePath)[currentLang]["statsWrong"]
	var statsSalary = Main.json_load(quotePath)[currentLang]["statsSalary"]
	var statsFines = Main.json_load(quotePath)[currentLang]["statsFines"]
	var statsBank = Main.json_load(quotePath)[currentLang]["statsBank"]
	
	$computer/background/grayblock/Label.text = statsStudents + ": " + String(students) + "\n" + statsCorrect + ": " + String(right) +"\n" + statsWrong + ": " + String(wrong+very_wrong) 
	$computer/background/grayblock/Label.text += "\n" + statsSalary + ": " +String(money) +"p."
	if very_wrong >=0: $computer/background/grayblock/Label.text += "\n" + statsFines + ": " + String(500*very_wrong) + "р."
	$computer/background/grayblock/Label.text += "\n" + statsBank + ": " +String(bank) +"p."

func comp_cam(type):
	$Camera2D.current=!type
	$comp_cam.current=type

func noend():
	comp_cam(false)
	$computer/background/shop.visible=false
	$computer/background/shop.stop()
	$computer/background/question.visible=true
	$computer/background/grayblock.visible = false
	for child in $players_stuff.get_children():
		$players_stuff.remove_child(child)
	new_student(level)

func get_name():
	if($room/student):
		 return [$room/student.first_name,$room/student.second_name]
	else:
		return ['First name','Second name']

func get_group():
	if($room/student):
		 return $room/student.group
	else:
		return "AAAA-00-11"

func new_student(num): #1- только отчет, 2- отч + флешка, 3 - отч + флешка+студак (всё)
	if $"computer/Games".get_blocked(): 
		return
	student_leave(num)
	$room/wall_up_left/wall_dc.new_student()
	print("\nnew student")
	var otchet = preload("res://mesh/otchet.tscn").instance()
	var studak = preload("res://mesh/studak.tscn").instance()
	var fm = preload("res://mesh/fm_1.tscn").instance()
	var spawn1 = $spawn1.transform.get_origin()
	var spawn2 = $spawn2.transform.get_origin()
	var spawn3 = $spawn3.transform.get_origin()
	yield(get_tree().create_timer(1.5),"timeout")
	$computer/background/radiation/checked.visible = false
	$computer/background/gear/checked.visible = false
	$computer/background/list/checked.visible = false
	$room/student.visible = true
	$room/student.generate()
	if num >=1:
		$players_stuff.add_child(otchet)
		$players_stuff/otchet.new_position(spawn1)
		$players_stuff/otchet.set_rotation_degrees(90) 
		$players_stuff.add_child(fm)
		$players_stuff/fm_1.new_position(spawn3)
	if num == 1:
		$players_stuff/fm_1.no_virus()
	if num >= 3:
		$players_stuff.add_child(studak)
		$players_stuff/studak.new_position(spawn2)
	children = $players_stuff.get_child_count()
		
	print("right: "+ String(right))
	print("wrong: "+ String(wrong))
	print("Very wrong: "+ String(very_wrong))
	student = true;

func student_leave(num):
	$"computer/Games".close_force()
	student = false;
	if $room/wall_up_left/wall_dc.wait:
		return
	if $computer.listing:
		return
	if num>3:
		num = 3
	elif num<1:
		num=1
	var super
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
	if $players_stuff.get_child_count() != 0:
		for child in $players_stuff.get_children():
			$players_stuff.remove_child(child)

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
	
func getApproved():
	# TODO: Сделать проверку, существует ли отчёт
	return $players_stuff/otchet.approved()

var audio_files

func _on_background_music_ready():
	# easter egg!
	if (Main.saveData["name"].sha256_text() == "5e5327a726b139360767945bab188c4af9033c4625cceedc53fb54431b0f9371"):
		audio_files = ["res://sounds/gameplayEasterEgg.ogg", "res://sounds/gameplayEasterEgg.ogg", "res://sounds/gameplayEasterEgg.ogg"]
	else:
		audio_files = ["res://sounds/gameplay1.ogg", "res://sounds/gameplay2.ogg", "res://sounds/gameplay3.ogg"]
	var nextsong = randi()%3
	var new_audio_file = audio_files[nextsong]
	var music = load(new_audio_file)
	music.set_loop(false)
	$background_music.stream = music
	$background_music.play()

func _on_background_music_finished():
	#var audio_files = ["res://sounds/gameplay1.ogg", "res://sounds/gameplay2.ogg", "res://sounds/gameplay3.ogg"]
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
	
	var music = load(new_audio_file)
	music.set_loop(false)
	$background_music.stream = music
	$background_music.play()


func _on_otchet_EasterEgg_Area_body_entered(body):
	if body.name == "otchet":
		$otchet_EasterEgg_Area/easterEggApplause.play()
		yield(get_tree().create_timer(5.0), "timeout")
		body.reset = true
