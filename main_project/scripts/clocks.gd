extends Node2D

var hours=0
var minutes=0
var time=0
var i=480 # 1440 - 24.00 часа 60минут - 60 секунд 480 - 8 часов утра 1075-17.45
var alarm = false
var end = false

func _process(delta):
	i+=delta
	time = int(i)
	
	#print(time)
	
	minutes = time % 60
	hours = time / 60

	$numbers_2/h_r.frame=hours%10
	$numbers_2/h_l.frame=hours/10
	$numbers_2/m_l.frame=minutes/10
	$numbers_2/m_r.frame=minutes%10
	
	if time>= 1080:
		$numbers_2/h_r.frame=8
		$numbers_2/h_l.frame=1
		$numbers_2/m_l.frame=0
		$numbers_2/m_r.frame=0
		if !alarm:
			$sound_alarm.play()
			alarm = true
			end = true
		else:
			if time >= 1082:
				$sound_alarm.stop()
				set_process(false)
		
	
