extends Node2D
var game = 'none' #db/prgm/vrs/none
var block = false;
var opened = false;
var real_names = 0
var real_sernames = 0
var student_verificeted_text = "Student verificated"
var student_nv_text = "Student doesn't exist"
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
#Фамилий и имен должно быть больше 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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


func db_game():
	get_parent().get_parent().comp_cam(true)
	if(block):
		return
	block = true
	real_names = 0
	real_sernames = 0
	$Database/ProgressBar.value = 0
	for i in range(1, 7):
		for j in range(1, 11):
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			get_node(node).text = ''
			get_node(node).pressed = false
			get_node(node).disabled = true
			get_node(node).set_scale(Vector2(1,1))
	var fname = get_parent().get_parent().get_name()[0]
	var sname = get_parent().get_parent().get_name()[1]
	var timer = get_parent().int_speed
	randomize()
	for i in range(1, 7):
		var real = false;
		var ran = randi()%10
		for j in range(1, 11):
			var ran_sec = randi()%20
			var index_name = randi()%arr_names.size()
			var index_sname = randi()%arr_sernames.size()
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			if ran>=5:
				if ran_sec == 1 && !real:
					get_node(node).text = fname
					real_names +=1
					real = true
				else:
					if !real and j==10:
						get_node(node).text = fname
						real_names +=1
						real = true
					else:
						while(arr_names[index_name] == fname):
							index_name = randi()%arr_names.size()
						get_node(node).text = arr_names[index_name]
			else:
				if ran_sec == 1 && !real:
					get_node(node).text = sname
					real_sernames +=1
					real = true
				else:
					if !real and j==10:
						get_node(node).text = sname
						real_sernames +=1
						real = true
					else:
						while(arr_sernames[index_sname]==sname):
							index_sname = randi()%arr_sernames.size()
						var add = ''
						if(randi()%2 == 1):
							add = 'a'
						get_node(node).text = arr_sernames[index_sname]+add
			if(get_node(node).text.length()>6):
				get_node(node).set_scale(Vector2(float(6)/float(get_node(node).text.length()),1))
			$Database/ProgressBar.value+=(1.67) #1.6 = 100/60   60 - колво кнопок
			yield(get_tree().create_timer(timer), "timeout")
	#Включаем кнопки
	for i in range(1, 7):
		for j in range(1, 11):
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			get_node(node).disabled = false;

func close():
	get_parent().get_parent().comp_cam(false)
	opened = false
	game = 'none'
	get_parent().get_node("Games").visible = false

func _on_Button_pressed():
	close()

func notification_node(text):
	$"notification".visible = true
	$"notification/n_text".text = text
	yield(get_tree().create_timer(2), "timeout")
	$"notification".visible = false
	$"notification/n_text".text = ""

func _on_DB_button_pressed():
	var fname = get_parent().get_parent().get_name()[0]
	var sname = get_parent().get_parent().get_name()[1]
	var truth = get_parent().get_parent().fio()
	var timer = get_parent().int_speed
	$Database/ProgressBar.value = 0
	var rn = 0
	var rsn = 0
	var check = true
	for i in range(1, 7):
		if !check: break
		for j in range(1, 11):
			check = false
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			if get_node(node).pressed:
				if get_node(node).text == sname:
					rsn +=1
				elif(get_node(node).text == fname):
					rn +=1
				else:
					break
			$Database/ProgressBar.value+=(1.67) #1.6 = 100/60   60 - колво кнопок
			yield(get_tree().create_timer(timer), "timeout")
			check = true
			
	if rsn == real_sernames && rn == real_names:
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
