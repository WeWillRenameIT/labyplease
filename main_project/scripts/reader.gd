extends Node2D

var num_en = 1
var notwork=0

var ip_1=true #Работает ли вход (если вставили флешку с вирусом, вход ломается на день)
var ip_2=true #Для теста выключим второй вход
var ip_3=true

var ip_1_in = false
var ip_2_in = false
var ip_3_in = false

var virus = false
var test = false
var speed = 1

#по умолчанию всегда горит зеленый, т.е. все входы исправны

func _ready():
	ip_1_in = false
	ip_2_in = false
	ip_3_in = false
	ip_1=true
	ip_2=true
	ip_3=true
	generate(get_parent().ports)
	numb_ports(num_en)
	print(num_en)


func _process(delta):
	if !ip_1: #Если вход не работает, то он горит красным
		$input_1/in_1.frame = 2
	if !ip_2:
		$input_2/in_2.frame = 2
	if !ip_3:
		$input_3/in_3.frame = 2

func _on_input_3_body_entered(body):  #Если вошла флешка - загорается желтый
	if ip_3 and body.name == "fm_1":
		virus = body.virus
		test = body.test
		speed = body.scan_speed
		ip_3_in = true
		$input_3/in_3.frame = 1

func _on_input_2_body_entered(body): 
	if ip_2 and body.name == "fm_1":
		virus = body.virus
		test = body.test
		speed = body.scan_speed
		ip_2_in = true
		$input_2/in_2.frame = 1

func _on_input_1_body_entered(body):  
	if ip_1 and body.name == "fm_1":
		virus = body.virus
		test = body.test
		speed = body.scan_speed
		ip_1_in = true
		$input_1/in_1.frame = 1

func _on_input_3_body_exited(body): #Если вышла - загорается зеленый
	if ip_3:
		ip_3_in = false
		$input_3/in_3.frame = 0

func _on_input_2_body_exited(body):
	if ip_2:
		ip_2_in = false
		$input_2/in_2.frame = 0

func _on_input_1_body_exited(body):
	if ip_1:
		ip_1_in = false
		$input_1/in_1.frame = 0

#Функция принимает число от 1 до 3х и создает ридер с данным количеством входов
func generate(num):
	if num > 3: #Защита от дураков
		num = 3
	elif num < 1:
		num = 1
	num_en = num

func numb_ports(num_en):
	if num_en == 1: #Настраиваем ридер 
		$stage.frame = 0
		$input_1.visible = true
		$input_2.visible = false
		$input_2/input_2_p.disabled = true
		$input_3.visible = false
		$input_3/input_3_p.disabled = true
		$polygon_1e.disabled = false
		$polygon_2e.disabled = true
		$polygon_3e.disabled = true
	elif num_en == 2:
		$stage.frame = 1
		$input_1.visible = true
		$input_2.visible = true
		$input_3.visible = false
		$input_3/input_3_p.disabled = true
		$polygon_1e.disabled = true
		$polygon_2e.disabled = false
		$polygon_3e.disabled = true
	elif num_en == 3:
		$stage.frame = 2
		$input_1.visible = true
		$input_2.visible = true
		$input_3.visible = true
		$polygon_1e.disabled = true
		$polygon_2e.disabled = true
		$polygon_3e.disabled = false

func get_inside(): #Вставлена ли флешка в ридер
	return (ip_1_in or ip_2_in or ip_3_in)

func get_port(): #Куда вставлена флешка
	if ip_1_in:
		return 1
	if ip_2_in:
		return 2
	if ip_3_in:
		return 3

func get_virus(): #Есть ли вирус
	return virus

func get_test(): #Пройдет ли тест
	return test

func get_speed(): #Передача скорости сканирования
	return speed

func on_ports(num):
	if num == 1:
		ip_1 = true
		ip_1_in = true
		notwork-=1
	if num == 2:
		ip_1 = true
		ip_1_in = true
		ip_2 = true
		ip_2_in = true
		notwork-=2
	if num == 3:
		ip_1 = true
		ip_1_in = true
		ip_2 = true
		ip_2_in = true
		ip_3 = true
		ip_3_in = true
		notwork-=3

func wait():
	$input_1/in_1.frame = 0
	$input_2/in_2.frame = 0
	$input_3/in_3.frame = 0

func off_port(num): #Выключение порта по номеру 1.2.3
	if num == 1:
		ip_1 = false
		ip_1_in = false
		notwork+=1
	if num == 2:
		ip_2 = false
		ip_2_in = false
		notwork+=1
	if num == 3:
		ip_3 = false
		ip_3_in = false
		notwork+=1
