extends Node2D

var time_b = 15 #Загрузка пк 
var test_speed = 1 #Скорость проверки теста
var vir_speed = 1 #Скорость проверки вируса
var int_speed = 10 #Скорость проверки студента
var boot_speed = 0 #Скорость загрузки
var on = true #Включен ли пк


func _process(delta):
	pass

func _on_list_b_pressed():
	$background/notify.text = "Workday is over, noone to check"
	$background/notify.visible = true
	yield(get_tree().create_timer(1.5),"timeout")
	$background/notify.visible = false


func _on_rad_b_pressed():
	$background/notify.text = "Workday is over, nothing to scan"
	$background/notify.visible = true
	yield(get_tree().create_timer(1.5),"timeout")
	$background/notify.visible = false


func _on_gear_b_pressed():
	$background/notify.text = "Workday is over, nothing to test"
	$background/notify.visible = true
	yield(get_tree().create_timer(1.5),"timeout")
	$background/notify.visible = false


func _on_book_b_pressed():
	print("book")


func _on_que_b_button_down():
	$background/Node2D.visible = true

func _on_que_b_button_up():
	$background/Node2D.visible = false

func loading():
	$background.visible = false
	$load.visible = true
	print(time_b)
	$load_text.visible = true
	$load.playing = true
	yield(get_tree().create_timer(time_b-vir_speed),"timeout")
	$background.visible = true
	$load.playing = false
	$load.visible = false
	$load_text.visible = false

func _on_turn_on_pressed():
	if on == false:
		print("end")
		
func _ready():
	pass

