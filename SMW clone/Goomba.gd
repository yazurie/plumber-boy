extends Area2D


var velocity = Vector2(0,0)

var SPEED = 200


func _physics_process(delta):
	
	velocity.x = SPEED
