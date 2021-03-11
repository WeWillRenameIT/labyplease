extends RigidBody2D

var mouse_drag_scale = 10
var max_velocity = 1500  # максимальная скорость
var friction_coef = 0.01 # коэффициент трения
var drag = false
var bruh = Vector2(0,0)


func _input(event):
	if event is InputEventMouseButton and not event.is_pressed() and event.button_index == BUTTON_LEFT:
		drag = false

func _on_lineyka_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			drag = true
			bruh = get_local_mouse_position()
		if event.button_index == BUTTON_RIGHT:
			visible = false

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

func new_position(vect):
	transform = Transform2D(0.0, vect)


