extends KinematicBody2D

var speed = 100
var velocity = Vector2()
export var direction = -1
var squish = 0
var active

func _ready():
	if active == true:
		if direction == 1:
			$AnimatedSprite.flip_h = true
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction 
		$AnimatedSprite.play("walk")


func _physics_process(delta):
	if active == true:
		if is_on_wall() or not $floor_checker.is_colliding() and is_on_floor():
			direction = direction * -1
			$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
			$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction  
		if $AnimatedSprite.animation == "walk":
			$CollisionShape2D.shape.extents = Vector2(48, 90)
		if $AnimatedSprite.animation == "squish":
			$CollisionShape2D.shape.extents = Vector2(24, 35)

		velocity.y += 20
	
		velocity.x = speed * direction
	
	
		velocity = move_and_slide(velocity,Vector2.UP)
	
	






func _on_top_checker_body_entered(body):
	if body.is_in_group("players"):
		body.bounce()
		$Squish.play()
		$AnimatedSprite.play("squish")
		speed = speed + 500
		squish = squish + 1
		print(squish)
		print ($CollisionShape2D.shape.extents)
		$side.start()
		$sides_checker/CollisionShape2D.disabled = true
		$sides_checker/CollisionShape2D2.disabled = true
		
		if squish == 2:
			$CollisionShape2D.disabled = true
			$AnimatedSprite.play("squish2")
			speed = 0
			set_collision_layer_bit(4,false)
			set_collision_mask_bit(0,false)
			$top_checker.set_collision_layer_bit(4,false)
			$top_checker.set_collision_mask_bit(0,false)
			$sides_checker.set_collision_layer_bit(4,false)
			$sides_checker.set_collision_mask_bit(0,false)
			$Timer.start()
			body.bounce()
			$Squish.play()
	
func _on_sides_checker_body_entered(body):
	if body.is_in_group("players"):
		print ("ouch")
		body.ouch(position.x)
	if body.is_in_group("killable") and squish == 1:
		body.ouch(position.x)
func _on_Timer_timeout():
	queue_free()




func _on_side_timeout():
	$sides_checker/CollisionShape2D.disabled = false
	$sides_checker/CollisionShape2D2.disabled = false


func _on_VisibilityNotifier2D_screen_exited():
	active = false


func _on_VisibilityNotifier2D_screen_entered():
	active = true
