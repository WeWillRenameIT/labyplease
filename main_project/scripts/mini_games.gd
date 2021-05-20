extends Node2D
var game = 'none' #db/prgm/vrs/none
var block = false;
var opened = false;
var cam_zoom = false;
var pause_time = 0.1
var block_prgm;
var block_db;
var db_state=0;#0-unknown, 1-yes, 2-no
var block_virus;
var virus_status=0; #0-unknown, 1-yes, 2-no
var real_names = 0
var real_sernames = 0
var virus_exist = "VIRUS DETECTED"
var virus_not_exist = "CLEAR"
var student_verificeted_text = "Student verificated"
var student_nv_text = "Student doesn't exist"
var prgm_error = "Vse slomalos GOSPODI."
var res_text = "Result: "
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
var math = ["+","-","*","/","%"]
var math_sighn;
#Called when the node enters the scene tree for the first time.
func _ready():
	$Background.visible = false

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
	if(!$Background.visible):
		$Background.visible=true
	if(game=='db'):
		if(db_state == 0): #не проходил проверку
			db_game()
		else:
			if db_state == 1: #студент есть
				notification_node(student_verificeted_text)
			elif db_state == 2: #no student
				notification_node(student_nv_text)
	elif(game=='prgm'):
		prgm_game()
	elif(game=='vrs'):
		vrs_game()

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

func prgm_reload():
	$Program/math_label.text = ""
	$Program/code_label.text = ""
	$Program/pgm_bar.value = 0
	$"Program/A-edit".text = ""
	$"Program/B-edit".text = ""
	$Program/calculating.text = ""
	$Program/result.text = ""

func vrs_game():#Пока просто заполнение бара
	$Program.visible = false
	$Virus.visible = true
	$Database.visible = false
	$Background.visible = false
	$Virus/ProgressBar.value = 0
	$Virus/ProgressBar/VirusButton.disabled = false
	if(virus_status == 1):
		notification_node(virus_exist);
	elif (virus_status == 2):
		notification_node(virus_not_exist);

func prgm_game():
	$Program.visible = true
	$Virus.visible = false
	$Database.visible = false
	$Background.frame = 1
	if(block_prgm):
		block_prgm = false
		$"Program/A-edit".editable = true
		$"Program/B-edit".editable = true
		$Program/pgm_button.disabled = false;
		return
		
	$"Program/A-edit".editable = false
	$"Program/B-edit".editable = false
	$Program/pgm_button.disabled = true;

	math_sighn = null
	var math_num = randi()%math.size();
	$Program/code_label.text=''
	$Program/calculating.text=''
	$Program/result.text=''
	$"Program/A-edit".text = ""
	$"Program/B-edit".text = ""
	$Button_close.disabled = true
	
	var spd_cmp = get_parent().test_speed #Computer speed
	var spd_flsh = get_parent().get_node('reader').get_speed() #Flash memory speed
	for i in range(0,spd_cmp):
		$Program/math_label.text = "a"+math[randi()%math.size()]+"b"
		if(!visible):
			return
		while(get_tree().paused):
			yield(get_tree().create_timer(pause_time), "timeout")
		yield(get_tree().create_timer(float(spd_flsh)), "timeout")
		$Program/code_label.text+=String(randi()%1000000)+"\n"
		$Program/pgm_bar.value+= float(100/spd_cmp)
	$Program/math_label.text = "a"+math[math_num]+"b"
	math_sighn = math[math_num]
	$"Program/A-edit".editable = true
	$"Program/B-edit".editable = true
	$Button_close.disabled = false

func db_game():
	$Program.visible = false
	$Virus.visible = false
	$Database.visible = true
	$Background.frame = 0
	if(block_db):
		block_db = false;
		return
	$"Database/column 1/Column_name_1".text = column_1
	$"Database/column 2/Column_name_2".text = column_2
	$"Database/column 3/Column_name_3".text = column_3
	#change_cam()
	if(block):
		return
	block = true
	$Database/ProgressBar.value = 0
	$Button_close.disabled = true
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
			if(!visible):
				return
			while(get_tree().paused):
				yield(get_tree().create_timer(pause_time), "timeout")
			yield(get_tree().create_timer(timer), "timeout")
	#Включаем кнопки
	$Button_close.disabled = false
	for i in range(1, 4):
		for j in range(1, 11):
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			get_node(node).disabled = false;

func _on_Button_pressed():
	close()

func notification_node(text):
	$Button_close.disabled = true
	$"notification".visible = true
	$"notification/n_text".text = text
	yield(get_tree().create_timer(2), "timeout")
	$"notification".visible = false
	$"notification/n_text".text = ""
	$Button_close.disabled = false
	close()

func db_reload():
	for i in range(1, 4):
		for j in range(1, 11):
			var node = "Database/column %s/cb_%s"
			node = node % [i,j]
			get_node(node).text = '';
			get_node(node).disabled = true;

func _on_DB_button_pressed():
	#выключаем кнопки
	$Button_close.disabled = true
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
			if(!visible):
				return
			while(get_tree().paused):
				yield(get_tree().create_timer(pause_time), "timeout")
			yield(get_tree().create_timer(timer), "timeout")
			check = true
	$Button_close.disabled = false
	if rn == 3:
		if truth:
			notification_node(student_verificeted_text)
			db_state = 1
			#get_parent().get_node("background/list/checked").visible = true
			#get_parent().get_node("background/list/checked").frame = 1
		else:
			db_state = 2
			notification_node(student_nv_text)
			#get_parent().get_node("background/list/checked").visible = true
			#get_parent().get_node("background/list/checked").frame = 0
	else:
		notification_node("ERROR-582")
	yield(get_tree().create_timer(3), "timeout")


func close():
	if(cam_zoom):
		change_cam()
	opened = false
	if(game=='db'):
		block = false;
		block_db = true;
		$Database.visible = false
		get_parent().listing = false;
	elif(game == 'prgm'):
		block = false;
		block_prgm = true;
		$Program.visible = false
		get_parent().gear = false;
	elif(game == 'vrs'):
		block = false;
		block_virus = true
		$Virus.visible = false
		get_parent().rad = false;
	game = 'none'
	get_parent().get_node("Games").visible = false

func close_force():
	if(cam_zoom):
		change_cam()
	opened = false
	block = false;
	block_db = false
	db_state = 0
	$Database.visible = false
	get_parent().listing = false;
	db_reload()
	block_prgm = false
	$Program.visible = false
	get_parent().gear = false;
	prgm_reload()
	block_virus = false
	virus_status = 0
	$Virus.visible = false
	get_parent().rad = false;
	game = 'none'
	get_parent().get_node("Games").visible = false
	emit_signal("timeout")

func _on_Button_hide_pressed():
	change_cam()

func _on_pgm_button_pressed():
	if($"Program/A-edit".text.empty() or $"Program/B-edit".text.empty()):
		return
	$Program/pgm_bar.value = 0;
	$"Program/A-edit".editable = false
	$"Program/B-edit".editable = false
	$Program/pgm_button.disabled = true;
	var a_int=int($"Program/A-edit".text)
	var b_int=int($"Program/B-edit".text)
	var res;
	var spd_cmp = get_parent().test_speed #Computer speed
	var spd_flsh = get_parent().get_node('reader').get_speed() #Flash memory speed
	match math_sighn:
		"+":res=a_int+b_int
		"-":res=a_int-b_int
		"*":res=a_int*b_int
		"/":res=a_int/b_int
		"%":res=a_int%b_int
	
	$Button_close.disabled = true
	
	for i in range(0,spd_cmp):
		if(!visible):
			return
		while(get_tree().paused):
			yield(get_tree().create_timer(pause_time), "timeout")
		$Program/code_label.text+=String(randi()%1000000)+"\n"
		if(i%3!=0):
			if($Program/calculating.text.empty()):
				$Program/calculating.text="Calculating"
			$Program/calculating.text+="."
		else:
			$Program/calculating.text="Calculating"
		yield(get_tree().create_timer(float(spd_flsh)), "timeout")
		$Program/pgm_bar.value+= float(100/spd_cmp)
	
	$Button_close.disabled = false
	
	if !get_parent().get_node('reader').get_test():
		if!(randi()%4):
			$Program/calculating.text="*&^$436*&^345%5673^$e^(&f(&75^$p)()_)y&*to8G"
			$Program/result.text = "CANNOT EXECUTE SAMPLE TEXT EXE"
			notification_node(prgm_error)
		else:
			$Program/result.text = String(res+randi()%3+1);
	else:
		$Program/result.text = res_text+String(res);
	
	if get_parent().get_node('reader').get_virus():
		get_parent().break_port()

func _on_Aedit_text_changed(new_text):
	if(!new_text.is_valid_integer() and !new_text.empty()):
		$"Program/A-edit".text = new_text[0] if new_text[0].is_valid_integer() else new_text[1] if new_text.length()>1 else '';
	if(new_text.length()>0 and !($"Program/B-edit".text.empty())):
		$Program/pgm_button.disabled = false;
	else:
		$Program/pgm_button.disabled = true;

func _on_Bedit_text_changed(new_text):
	if(!new_text.is_valid_integer() and !new_text.empty()):
		$"Program/B-edit".text = new_text[0] if new_text[0].is_valid_integer() else new_text[1] if new_text.length()>1 else '';
	if (math_sighn == "/" or math_sighn == "%") and int(new_text)==0:
		$"Program/B-edit".text = ''
		return
	if(new_text.length()>0 and !($"Program/A-edit".text.empty()) and new_text.is_valid_integer()):
		$Program/pgm_button.disabled = false;
	else:
		$Program/pgm_button.disabled = true;


func _on_VirusButton_pressed():
	var timev = get_parent().vir_speed
	var status = get_parent().get_node('reader').get_virus()
	$Button_close.disabled = true
	$Virus/ProgressBar.value = 0
	$Virus/ProgressBar/radiation.rotation_degrees=0
	$Virus/ProgressBar/VirusButton.disabled = true
	block_virus = true
	
	for i in range(0,20):
		if(!visible):
			return
		while(get_tree().paused):
			yield(get_tree().create_timer(pause_time), "timeout")
		yield(get_tree().create_timer(timev), "timeout")
		$Virus/ProgressBar.value += 5
		$Virus/ProgressBar/radiation.rotation_degrees+=18
	$Virus/ProgressBar/VirusButton.disabled = false
	
	block_virus = false
	$Button_close.disabled = false
	if(status): 
		virus_status = 1 
		notification_node(virus_exist);
	else: 
		virus_status = 2
		notification_node(virus_not_exist);

func get_blocked():
	return (block_db or block_virus or block_prgm)
