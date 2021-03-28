extends Node2D
var game = 'none' #db/prgm/vrs/none
var block = false;
var opened = false;
var cam_zoom = false;
var real_names = 0
var real_sernames = 0
var student_verificeted_text = "Student verificated"
var student_nv_text = "Student doesn't exist"
var column_1 = "First ame"
var column_2 = "Second name"
var column_3 = "Group"
var arr_names = ["Alexey",
"Alexander",
"Viktor",
"Ilya",
"Konstantin",
"Petr",
"Igor",
"Denis",
"Dmitriy",
"Daniil",
"Vladislav",
"Alexandra",
"Polina",
"Viktorya",
"Irina",
"Natalya",
"Marina",
"Maria",
"Anna",
"Ekaterina"]
var arr_sernames = ["Ivanov",
"Petrov",
"Portyanov",
"Vetrov",
"Dmitriev",
"Kirpichev",
"Vodyanov",
"Dyatlov",
"Kamenshikov",
"Artemov"]
var letters = ["A","B","C","D","E","F",'G','H','I','J','K','L','M','N','O','P',
'Q','R','S','T','U','V','W','X','Y','Z']
#Фамилий и имен должно быть больше 10
#Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_cam():
	cam_zoom = !cam_zoom
	if(game == "db"):
		pass
	elif(game == 'prgm'):
		pass
	elif(game == 'vrs'):
		pass
	get_parent().get_parent().comp_cam(cam_zoom)

func game_type(type):
	if(type=='db'):
		game='db'
	elif(type=='prgm'):
		game='prgm'
	elif(type=='vrs'):
		game='vrs'
	else:
		game='none'

func game():
	if(game=='db'):
		db_game()
	elif(game=='prgm'):
		pass
	elif(game=='vrs'):
		pass

func play(type):
	if(opened):
		close()
	else:
		opened = true
		game_type(type)
		game()

func generate_group():
	randomize()	
	var first='';
	first = letters[randi()%letters.size()]+letters[randi()%letters.size()]+letters[randi()%letters.size()]+letters[randi()%letters.size()]
	var num = randi()%100;
	if num<10:
		first = first+'-0'+String(num)+'-2'+String(randi()%10)
	else:
		first = first+'-'+String(num)+'-2'+String(randi()%10)
	return first

func db_game():
	$Database.visible = true
	$"Database/column 1/Column_name_1".text = column_1
	$"Database/column 2/Column_name_2".text = column_2
	$"Database/column 3/Column_name_3".text = column_3
	#change_cam()
	if(block):
		return
	block = true
	$Database/ProgressBar.value = 0
	for i in range(1, 4):
		for j in range(1, 11):
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			get_node(node).text = ''
			get_node(node).pressed = false
			get_node(node).disabled = true
			get_node(node).set_scale(Vector2(1,1))
	var fname = get_parent().get_parent().get_name()[0]
	var sname = get_parent().get_parent().get_name()[1]
	var group = get_parent().get_parent().get_group()
	var timer = get_parent().int_speed
	randomize()
	for i in range(1, 4):
		var real = false;
		for j in range(1, 11):
			var ran_sec = randi()%7
			var index_name = randi()%arr_names.size()
			var index_sname = randi()%arr_sernames.size()
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			if i==1:
				if ran_sec == 1 && !real:
					get_node(node).text = fname
					real = true
				else:
					if !real and j==10:
						get_node(node).text = fname
						real = true
					else:
						while(arr_names[index_name] == fname):
							index_name = randi()%arr_names.size()
						get_node(node).text = arr_names[index_name]
			elif i==2:
				if ran_sec == 1 && !real:
					get_node(node).text = sname
					real = true
				else:
					if !real and j==10:
						get_node(node).text = sname
						real = true
					else:
						while(arr_sernames[index_sname]==sname):
							index_sname = randi()%arr_sernames.size()
						var add = ''
						if(randi()%2 == 1):
							add = 'a'
						get_node(node).text = arr_sernames[index_sname]+add
			else:
				if ran_sec == 1 && !real:
					get_node(node).text = group
					real = true
				else:
					if !real and j==10:
						get_node(node).text = group
						real = true
					else:
						var nrg = generate_group()
						while(nrg==group):
							nrg = generate_group()
						get_node(node).text = nrg
			$Database/ProgressBar.value+=(3.34) #3.34 = 100/30   30 - колво кнопок
			yield(get_tree().create_timer(timer), "timeout")
	#Включаем кнопки
	for i in range(1, 4):
		for j in range(1, 11):
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			get_node(node).disabled = false;

func _on_Button_pressed():
	close()

func notification_node(text):
	$"notification".visible = true
	$"notification/n_text".text = text
	yield(get_tree().create_timer(2), "timeout")
	$"notification".visible = false
	$"notification/n_text".text = ""

func _on_DB_button_pressed():
	#выключаем кнопки
	for i in range(1, 4):
		for j in range(1, 11):
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			get_node(node).disabled = true;
	var fname = get_parent().get_parent().get_name()[0]
	var sname = get_parent().get_parent().get_name()[1]
	var group = get_parent().get_parent().get_group()
	var truth = get_parent().get_parent().fio()
	var timer = get_parent().int_speed
	$Database/ProgressBar.value = 0
	var rn = 0
	var check = true
	for i in range(1, 4):
		if !check: break
		for j in range(1, 11):
			check = false
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			if get_node(node).pressed:
				if get_node(node).text == sname or get_node(node).text == fname or get_node(node).text == group:
					rn +=1
				else:
					break
			$Database/ProgressBar.value+=(3.34)
			yield(get_tree().create_timer(timer), "timeout")
			check = true
			
	if rn == 3:
		if truth:
			notification_node(student_verificeted_text)
			get_parent().get_node("background/list/checked").visible = true
			get_parent().get_node("background/list/checked").frame = 1
		else:
			notification_node(student_nv_text)
			get_parent().get_node("background/list/checked").visible = true
			get_parent().get_node("background/list/checked").frame = 0
	else:
		notification_node("ERROR-582")
	block = false
	yield(get_tree().create_timer(2), "timeout")
	close()


func close():
	if(cam_zoom):
		change_cam()
	opened = false
	if(game=='db'):
		$Database.visible = false
	elif(game == 'prgm'):
		$Program.visible = false
	elif(game == 'vrs'):
		$Virus.visible = false
	game = 'none'
	get_parent().get_node("Games").visible = false


func _on_Button_hide_pressed():
	change_cam()
