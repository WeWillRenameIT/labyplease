extends Node2D

var notify = true
var test_speed = 5 #Скорость проверки теста
var vir_speed = 5 #Скорость проверки вируса
var int_speed = 5 #Скорость проверки студента
var boot_speed = 5 #Скорость загрузки пк. Число отнимается от 20 и ставится таймер таймер(20-5) по стандарту
var boot= false #Ускоритель загрузки SAVE
var test_s = false #Ускоритель проверки теста SAVE
var vir = false #Ускоритель проверки вируса SAVE
var check = false #Ускоритель проверки студента SAVE
var on = true #Включен ли пк
var rad = false #Идет ли проверка на вирусы
var gear = false #Идет ли тестирование
var rad_work = false #Прошла ли проверка на вирусы
var gear_work = false #Прошел ли тест
var inside = false #Вставлена ли флешка
var list = false#Прошла ли проверка
var listing = false #Проверка по глобальному списку
var shop = 0
var ports = 1 #SAVE

func _process(delta):
	#Проверка на бонусы
	if boot:
		boot_speed = 15
	if test_s:
		test_speed = 10
	if vir:
		vir_speed = 10
	if check:
		int_speed = 10
	
	var virus = $reader.get_virus() #Есть ли вирус на флешке
	var test = $reader.get_test() #Пройдет ли флешка тест
	var port = $reader.get_port() #В какой порт вставлена флешка
	var speed = $reader.get_speed() #Скорость сканирования флешки
	var fio = get_parent().fio() #Получаем правильность данных из студака
	
	inside = $reader.get_inside() #Проверяем вставлена ли флешка
	#Если вставлена
	if inside and notify: 
		$background/notify.visible = true
		yield(get_tree().create_timer(1.5),"timeout")
		$background/notify.visible = false
		notify = false
	elif !inside:
		rad_work = false 
		rad = false
		gear_work = false
		gear = false
		notify = true
		$background/notify.visible = false
		
	if inside and gear and !rad and !listing:
		$background/ProgressBarTest.visible = true
		$background/ProgressBarTest.value += $background/ProgressBarTest.step * speed * test_speed
		$background/label.visible = false
	else: 
		$background/ProgressBarTest.visible = false
		$background/ProgressBarTest.value = 0 
	
	if inside and rad and !gear and !listing: 
		$background/ProgressBarRad.visible = true
		$background/ProgressBarRad.value += $background/ProgressBarRad.step * speed * vir_speed
		$background/label.visible = false
	else: 
		$background/ProgressBarRad.visible = false
		$background/ProgressBarRad.value = 0
	
	if listing and !gear and !rad and (get_parent().children() == 3):
		$background/ProgressBarCheck.visible =true
		$background/ProgressBarCheck.value += $background/ProgressBarCheck.step * int_speed
		$background/label.visible = false
	else:
		$background/ProgressBarCheck.visible = false
		$background/ProgressBarCheck.value = 0
	
	if $background/ProgressBarRad.value >=100:
		rad_work = true
		rad = false
		$background/ProgressBarRad.value = 0
	
	if $background/ProgressBarCheck.value >=100:
		list = true
		listing = false
		$background/ProgressBarCheck.value = 0
	
	#Если флешка заражена и прошел тест, то выключаем пк и ломаем вход ридера
	if $background/ProgressBarTest.value >=100:
		if virus:
			$background.visible = false
			$bruh.visible = true
			$AnimatedSprite.frame = 0
			$reader.off_port(port)
			inside = false
		gear_work = true
		gear = false
		$background/ProgressBarTest.value = 0
	
	#Прошол ли поиск студента в базе
	if list:
		$background/label.text = "Student: " + String(fio)
		$background/label.visible = true
		yield(get_tree().create_timer(1.5),"timeout")
		$background/ProgressBarCheck.value = 0
		$background/label.visible = false
		list = false
	
	#Прошело сканирование на вирусы
	if rad_work and virus:
		$background/label.text = "Virus detected!!!"
		$background/label.visible = true
		yield(get_tree().create_timer(1.5),"timeout")
		$background/label.visible = false
		rad_work = false
	if rad_work and !virus:
		$background/label.text = "Virus free"
		$background/label.visible = true
		yield(get_tree().create_timer(1.5),"timeout")
		$background/label.visible = false
		rad_work = false
	
	#Прошел тест программы
	if gear_work and test:
		$background/label.text = "Test pass"
		$background/label.visible = true
		yield(get_tree().create_timer(1.5),"timeout")
		$background/label.visible = false
		gear_work = false
	elif gear_work and !test:
		$background/label.text = "Test failed!!!"
		$background/label.visible = true
		yield(get_tree().create_timer(1.5),"timeout")
		$background/label.visible = false
		gear_work = false
	
	#Если время вышло включаем магазин
	if $clocks.end:
		$background/shop.visible = true
		$background/shop.playing = true
	
	#Если все порты сломаны - конец уровня
	if ports<=$reader.notwork:
		no_lives()
		set_process(false)

func _on_list_b_pressed():
	if !$clocks.end and !rad and !gear and get_parent().children()==3 and get_parent().open(): listing = true

func _on_rad_b_pressed():
	if !$clocks.end and !gear and !listing: rad = true #Если идет тест, то не можем проверить на вирусы

func _on_gear_b_pressed():
	if !$clocks.end and !rad and !listing: gear = true #Если проверяется на вирусы, не можем тестировать


func _on_book_b_pressed():
	print("book") #Тут надо вывести окно с подсказками в игре что куда тыкать и тп

func _on_que_b_button_down():
	$background/Node2D.visible = true

func _on_que_b_button_up():
	$background/Node2D.visible = false

func no_lives():
	get_parent().end()
	$background/grayblock/note_2.text="Reader is broken."
	$background/grayblock/repair_reader.visible=true
	$background/grayblock/repair_reader.disabled=false

func loading():
	$background.visible = false
	$load.visible = true
	$load_text.visible = true
	$load.playing = true
	yield(get_tree().create_timer(20-boot_speed),"timeout")
	$background.visible = true
	$load.playing = false
	$load.visible = false
	$load_text.visible = false

func _on_turn_on_pressed():
	if on == false:
		loading()
		$bruh.visible = false
		on = true
		$AnimatedSprite.frame = 0
	else: 
		rad = false
		gear = false
		on = false
		$AnimatedSprite.frame = 1
		$bruh.visible = false
		$background.visible = false
		
func _ready():
	pass

func check():
	if boot:
		$background/shop_menu/test_ssd.frame = 2
		$background/shop_menu/test_ssd/ssd_b.disabled=true
	else:
		$background/shop_menu/test_ssd.frame = 0
		$background/shop_menu/test_ssd/ssd_b.disabled=false
	if test_s:
		$background/shop_menu/cpu.frame = 2
		$background/shop_menu/cpu/cpu_b.disabled=true
	else:
		$background/shop_menu/cpu.frame = 0
		$background/shop_menu/cpu/cpu_b.disabled=false
	if vir:
		$background/shop_menu/antivirus.frame = 2
		$background/shop_menu/antivirus/vir_b.disabled=true
	else:
		$background/shop_menu/antivirus.frame = 0
		$background/shop_menu/antivirus/vir_b.disabled=false
	if check:
		$background/shop_menu/internet.frame = 2
		$background/shop_menu/internet/int_b.disabled=true
	else:
		$background/shop_menu/internet.frame = 0
		$background/shop_menu/internet/int_b.disabled=false
	if ports == 3:
		$background/shop_menu/more_reader.frame = 2
		$background/shop_menu/more_reader/read_b.disabled=true
	else:
		$background/shop_menu/more_reader.frame = 0
		$background/shop_menu/more_reader/read_b.disabled=false

func _on_shop_b_pressed():
	$background/shop_menu.visible = true
	$background/shop_menu/total.text = String(get_parent().bank)+"p."
	check()

func _on_next_level_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	$background/shop_menu.visible = false
	shop = 0
	$background/shop_menu/count.text = ""


func _on_ssd_b_pressed():
	$background/shop_menu/test_ssd.frame = 1
	$background/shop_menu/test_ssd/ssd_b.disabled=true
	shop+=10000
	$background/shop_menu/count.text = String(shop)+"p."


func _on_cpu_b_pressed():
	$background/shop_menu/cpu.frame = 1
	$background/shop_menu/cpu/cpu_b.disabled=true
	shop+=30000
	$background/shop_menu/count.text = String(shop)+"p."


func _on_int_b_pressed():
	$background/shop_menu/internet.frame = 1
	$background/shop_menu/internet/int_b.disabled=true
	shop+=15000
	$background/shop_menu/count.text = String(shop)+"p."

func _on_read_b_pressed():
	$background/shop_menu/more_reader.frame = 1
	$background/shop_menu/more_reader/read_b.disabled=true
	shop+=5000
	$background/shop_menu/count.text = String(shop)+"p."

func _on_vir_b_pressed():
	$background/shop_menu/antivirus.frame = 1
	$background/shop_menu/antivirus/vir_b.disabled=true
	shop+=7000
	$background/shop_menu/count.text = String(shop)+"p."


func _on_Buy_pressed():
	var money = get_parent().bank
	if money<shop:
		$background/shop_menu/Label2.visible=true
		$background/shop_menu/Label2.text = "Not enough money!"
		yield(get_tree().create_timer(1.5),"timeout")
		$background/shop_menu/Label2.visible=false
	else:
		get_parent().set_bank(money-shop)
		$background/shop_menu/count.text = "0p."
		if $background/shop_menu/antivirus.frame == 1:
			vir = true
		if $background/shop_menu/internet.frame == 1:
			check = true
		if $background/shop_menu/cpu.frame == 1:
			test_s = true
		if $background/shop_menu/test_ssd.frame == 1:
			boot = true
		if $background/shop_menu/more_reader.frame == 1:
			ports+=1
			$reader._ready()
	check()
	$background/shop_menu/total.text = String(get_parent().bank)+"p."
	$background/grayblock/repair_reader.disabled=true
	$background/grayblock/repair_reader.visible=false


func _on_repair_reader_pressed():
	if get_parent().bank<1000:
		$background/grayblock/note_3.visible=true
		yield(get_tree().create_timer(1.5),"timeout")
		$background/grayblock/note_3.visible=false
	else:
		get_parent().set_bank(get_parent().bank-1000)
		$reader.notwork = 0
		get_parent().noend()
		set_process(true)
		$reader/input_3/in_3.frame = 0
		$reader/input_2/in_2.frame = 0
		$reader/input_1/in_1.frame = 0
		$reader._ready()
