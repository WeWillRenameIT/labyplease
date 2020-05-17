extends RigidBody2D

var mouse_drag_scale = 10
var max_velocity = 800  # максимальная скорость
var friction_coef = 1.13 # коэффициент трения
var pages = 10
var cp = 0
var test = false
var drag = false
var bruh = Vector2(0,0)
var approved = false
var check_status = false
var localeFilePath = "res://texts/otchet.json" # Файл локали
var workCheckCorrect
var workCheckIncorrect

func _ready():
	generate()
	cp = 0
	$as_right.frame = 0
	$as_right.visible = true
	$left_a.visible = false
	$sec_col.disabled = true
	$main_col.disabled = false
	$ot_1.visible = false
	$right_a.visible = true
	$right_a/right.disabled = false
	$left_a.visible = false
	
	# Загрузить локализацию
	workCheckCorrect = Main.json_load(localeFilePath)[Main.currentLang]["correct"]
	workCheckIncorrect = Main.json_load(localeFilePath)[Main.currentLang]["incorrect"]

func _process(delta):
	if check_status and cp==0:
		$as_right/status_main.visible = true
		if test:
			$as_right/status_main.text= 'True'
		else:
			$as_right/status_main.text= 'False'
	if cp == pages:
		$ot_1/status.visible = true
	else:
		$ot_1/status.visible = false
	if cp !=0 :
		$Control.visible = false
	else: 
		$Control.visible = true
	if approved:
		$right_a.visible = false
		$right_a/right.disabled = true

func _input(event):
	if event is InputEventMouseButton and not event.is_pressed() and event.button_index == BUTTON_LEFT:
		drag = false

func _integrate_forces(state):
	state.angular_velocity = 0 #Занулим скорость вращения флешки
	if drag:
		state.linear_velocity = get_global_mouse_position() - global_position - Vector2(bruh.x,bruh.y)
		state.linear_velocity *= mouse_drag_scale
		# При слишком большой скорости объект начинает проходить сквозь другие объекты.
		# Код далее ограничивает максимальную скорость.
		var vector_length = state.linear_velocity.length()
		if vector_length >= max_velocity:
			state.linear_velocity /=  vector_length / max_velocity # не зря учил алгем
	# Код далее задаёт трение.
	if !drag and state.linear_velocity.length() != 0:
		state.linear_velocity /= friction_coef

func _on_otchet_input_event(viewport, event, shape_idx):
	pass
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			drag = true
			set_rotation_degrees(0) 
			bruh = get_local_mouse_position()
		if event.button_index == BUTTON_RIGHT:
			set_rotation_degrees(0)


func _on_right_a_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				if cp != pages:
					cp+=1
					$as_right/pages.visible = true
					$as_right/pages.text = String((cp+1)*2-1)
					$ot_1/pages.visible = true
					$ot_1/pages.text = String((cp)*2)
					$as_right.frame = 1
					$sec_col.disabled = false
					$left_a/left.disabled = false
					$left_a.visible = true
					$right_a.visible = true
					$ot_1.visible = true
				elif cp == pages:
					check_status = true
					$as_right/pages.visible = false
					print("test is: "+ String(test))
					if test:
						$ot_1/status.text = workCheckCorrect
					else:
						$ot_1/status.text = workCheckIncorrect
					$main_col.disabled = true
					$right_a/right.disabled = true
					$right_a.visible = false
					$as_right.visible = false
				else:
					$as_right/pages.visible = true
					$as_right/pages.text = String((cp+1)*2-1)
					$ot_1/pages.visible = true
					$ot_1/pages.text = String((cp)*2)
					$main_col.disabled = false
					$right_a/right.disabled = false
					$right_a.visible = true
					$as_right.visible = true
				print(cp)


func _on_left_a_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT: #ЛКМ - листаем по страничке назад
				$as_right.visible = true
				$right_a/right.disabled = false
				if cp != 0:
					$as_right/pages.visible = true
					$as_right/pages.text = String((cp+1)*2-3)
					$ot_1/pages.visible = true
					$ot_1/pages.text = String((cp)*2-2)
					$main_col.disabled = true
					$right_a.visible = true
					$left_a/left.disabled = false
					$left_a.visible = true
					cp-=1
					if cp == 0:
						$as_right/pages.visible = false
						$main_col.disabled = false
						$as_right.frame = 0
						$as_right.visible = true
						$sec_col.disabled = true
						$left_a/left.disabled = true
						$left_a.visible = false
						$right_a/right.disabled = false
						$right_a.visible = true
						$ot_1.visible = false
				print(cp)
			if event.button_index == BUTTON_RIGHT: #ПКМ - мгновенно перемещаемся к началу
				cp = 0
				$as_right/pages.visible = false
				$main_col.disabled = false
				$as_right.frame = 0
				$as_right.visible = true
				$sec_col.disabled = true
				$left_a/left.disabled = true
				$left_a.visible = false
				$right_a/right.disabled = false
				$right_a.visible = true
				$ot_1.visible = false

func generate():
	randomize()
	if randi()%10 > 1:
		test = true
	else:
		test = false
	pages = randi()%10 + 2 
	if pages <= 3:
		test = 0

func new_position(vect):
	transform = Transform2D(0.0, vect)

func approved():
	return approved

func test():
	return test


func _on_stampable_input_event(viewport, event, shape_idx):
	pass
	"""if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			drag = true
			set_rotation_degrees(0) 
			bruh = get_local_mouse_position()
		if event.button_index == BUTTON_RIGHT:
			set_rotation_degrees(0)"""

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			drag = true
			set_rotation_degrees(0) 
			bruh = get_local_mouse_position()
		if event.button_index == BUTTON_RIGHT:
			set_rotation_degrees(0)
