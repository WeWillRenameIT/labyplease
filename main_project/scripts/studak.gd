extends RigidBody2D

var mouse_drag_scale = 10
var max_velocity = 800  # максимальная скорость
var friction_coef = 1.13 # коэффициент трения
var fio = true
var open = false
var drag = false
var bruh = Vector2(0,0)

func _ready():
	generate()
	open = false
	$sec_col.disabled = true
	$main_col.disabled = false
	$as_right.visible = true
	$ot_1.visible = false
	$right_a.visible = true
	$left_a.visible = false
	$ot_1/name.text = get_parent().get_parent().get_name()[0]
	$ot_1/sername.text = get_parent().get_parent().get_name()[1]
	$ot_1/group.text = get_parent().get_parent().get_group()

func _input(event):
	if event is InputEventMouseButton and not event.is_pressed() and event.button_index == BUTTON_LEFT:
		drag = false
		z_index = -2

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


func _on_right_a_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				if !open:
					print("fio in docs: "+String(fio))
					open = true
					$sec_col.disabled = false
					$left_a.visible = true
					$right_a.visible = false
					$ot_1.visible = true

func _on_left_a_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				if open:
					open = false
					$sec_col.disabled = true
					$left_a.visible = false
					$right_a.visible = true
					$ot_1.visible = false

func generate():
	randomize()
	var t = randi()%101
	if t== 0:
		fio = false


func new_position(vect):
	transform = Transform2D(0.0, vect)

func fio():
	return fio
func open():
	return open
