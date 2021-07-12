extends Area2D


func ded():
	$Coinsfx.play()
	$Timer.start()
	modulate.a = 0

func _on_Timer_timeout():
	queue_free()
