extends Area2D



func _on_BreakableBlock_body_entered(body):
	if body.is_in_group("players"):
		print("monke")
