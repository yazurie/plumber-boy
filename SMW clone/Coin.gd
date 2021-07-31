extends Area2D


func ded():
	$Coinsfx.play()
	$Timer.start()
	modulate.a = 0

func _on_Timer_timeout():
	queue_free()


func _on_Coin1_body_entered(body):
	if body.is_in_group("players"):
		ded()
