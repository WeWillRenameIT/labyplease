extends Sprite

var cik = 0
var new_student = false
var start = true
var wait = false


func _process(delta):
	if start:
		$queue/tolpa.play()
		$queue/queue1.frame = blink(6)
		$queue/queue2.frame = blink(6)
		$queue/queue3.frame = blink(6)
		$queue/queue4.frame = blink(6)
		start = false
	
	if cik >= 4:
		cik = 0
	
	if new_student:
		new_student()


func blink(num):
	randomize()
	return randi()%num

func get_ns():
	return new_student

func get_wait():
	return wait

func new_student():
	new_student = false
	wait = true
	var que = blink(4)
	$open_anim.frame = 1
	yield(get_tree().create_timer(1),"timeout")
	if cik == 0:
		$queue/queue1.frame = blink(6)
	elif cik == 1:
		$queue/queue2.frame = blink(6)
	elif cik == 2:
		$queue/queue3.frame = blink(6)
	elif cik == 3:
		$queue/queue4.frame = blink(6)
	$open_anim.frame = 0
	cik+=1
	yield(get_tree().create_timer(randi()%3),"timeout")
	wait = false
