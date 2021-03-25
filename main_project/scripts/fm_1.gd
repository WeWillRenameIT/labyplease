#extends Node2D
extends RigidBody2D

var mouse_drag_scale = 10
var max_velocity = 300  # максимальная скорость
var friction_coef = 100 # коэффициент трения
var test = true #Что выведет компьютер при тестированнии программы на флешке
var virus = false #Содержит ли флешка вирусы
var scan_speed = 1 #Скорость сканирования флешки от единицы!
var drag = false
var bruh = Vector2(0,0)

func _ready():
	generate()
	print("virus: "+String(virus))
	print("test: "+String(test))
	print("speed: "+String(scan_speed))
	
func _on_fm_1_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			set_rotation_degrees(rotation_degrees+5) 
		if event.button_index == BUTTON_WHEEL_DOWN:
			set_rotation_degrees(rotation_degrees-5) 
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				drag = true
				z_index = -1
				#set_rotation_degrees(0) 
				bruh = get_local_mouse_position()
			if event.button_index == BUTTON_RIGHT:
				set_rotation_degrees(0)

func _input(event):
	if event is InputEventMouseButton and not event.is_pressed() and event.button_index == BUTTON_LEFT:
		drag = false
		z_index = -2

func _integrate_forces(state):
	state.angular_velocity = 0 #Занулим скорость вращения флешки
	if drag:
		state.linear_velocity = get_global_mouse_position() - global_position - Vector2(bruh.y,-bruh.x)
		state.linear_velocity *= mouse_drag_scale
		# При слишком большой скорости объект начинает проходить сквозь другие объекты.
		# Код далее ограничивает максимальную скорость.
		var vector_length = state.linear_velocity.length()
		if vector_length >= max_velocity:
			state.linear_velocity /=  vector_length / max_velocity # не зря учил алгем
	# Код далее задаёт трение.
	if !drag and state.linear_velocity.length() != 0:
		state.linear_velocity /= friction_coef

func get_frame():
	return $fms_1.frame

func get_speed():
	return scan_speed

func generate():
	randomize()
	$fms_1.frame = randi()%7 #Номер спрайта с флешкой
	if randi()%10 >=2: 
		virus = false
	else:
		virus = true
	if randi()%10 >=3:
		test = true
	else:
		test = false
	scan_speed = randi()%5 + 1

func new_position(vect):
	transform = Transform2D(0.0, vect)
	set_rotation_degrees(-90) 
	
func test():
	return test
