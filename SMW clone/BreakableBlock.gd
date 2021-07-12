extends Area2D


func Animation():
	$AnimatedSprite.play("default")

func broke():
	$AnimatedSprite.stop()
	$AnimatedSprite.play("broke")
	$Coinsf.play()
