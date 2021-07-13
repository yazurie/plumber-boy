extends KinematicBody2D






var jump_timer = 0
var velocity = Vector2()
const SHORTHOP = -600
export var SPEED = 0
const JUMPFORCE = -1230
var GRAVITY = 30
export var MAXSPEED = 450
var sprint = 0
var friction = 2
var accel = 0.1
onready var coyote = $Coyote



func jump_cut():
	if velocity.y < -600:
		velocity.y = -600


func input(delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Level1.tscn")
	
	var timedict = OS.get_time()
	var hour = timedict.hour;
	
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMPFORCE + GRAVITY
			$Jumpsfx.play()
		if not is_on_floor():
			$Buffer.start()
	if Input.is_action_pressed("right"):
		SPEED = 350
	if not Input.is_action_pressed("right") and SPEED > 0:
		
		SPEED = -50
		
	if Input.is_action_just_released("jump"):
		jump_cut()
		velocity.y = lerp(velocity.y, JUMPFORCE, 0.1) + GRAVITY * delta
	if Input.is_action_pressed("left"):
		SPEED = -350
	if not Input.is_action_pressed("left") and SPEED < 0:
		SPEED += 50
	if Input.is_action_pressed("Run") and Input.is_action_pressed("right"):
		sprint = 200
		velocity.x = lerp(velocity.x, velocity.x + sprint, 0.08)
	if Input.is_action_pressed("Run") and Input.is_action_pressed("left"):
		sprint = -200
		velocity.x = lerp(velocity.x, velocity.x + -162, 0.08)
		if velocity.x < -512:
			velocity.x = -512
		print (velocity.x)
	if Input.is_action_pressed("Run") and not is_on_floor() and Input.is_action_pressed("right"):
		if velocity.y > 0:
			GRAVITY = 20
		velocity.y = velocity.y + -5
	if Input.is_action_pressed("Run") and not Input.is_action_pressed("right"):
		sprint = 0
	if Input.is_action_pressed("Run") and not Input.is_action_pressed("left"):
		sprint = 0
	if Input.is_action_just_released("right"):
		velocity.x = lerp(velocity.x, 0, friction)
	if Input.is_action_just_released("left"):
		velocity.x = lerp(velocity.x, 0, -friction)
func Animation():
	if Input.is_action_pressed("right"):
		$Sprite.play("Walk")
		$Sprite.flip_h = true
		
	if Input.is_action_pressed("left"):
		$Sprite.play("Walk")
		$Sprite.flip_h = false
	if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		$Sprite.play("idle")
	
	if not is_on_floor():
		$Sprite.play("Air")
	if Input.is_action_pressed("Run") and Input.is_action_pressed("right") and is_on_floor() or Input.is_action_pressed("Run") and Input.is_action_pressed("left") and is_on_floor():
		$Sprite.set_speed_scale(2)
	else:
		$Sprite.set_speed_scale(1)
	
func _physics_process(delta):
	input(delta)
	Animation()
	
	if velocity.x > 350:
		friction = -0.2
	if is_on_ceiling():
		velocity.y = 25
	
	if velocity.x > 0 and is_on_floor():
		$Sprite.play("walk")
	
	if not is_on_floor():
		if velocity.y > 0:
			GRAVITY = 55
			$Sprite.play("Fall")
		velocity.y += GRAVITY
		friction = -0.01
		if Input.is_action_pressed("right"):
			velocity.x = velocity.x + 5
			
		if Input.is_action_pressed("left"):
			velocity.x = velocity.x + -5
	velocity.x = lerp(velocity.x, SPEED, accel) + sprint
	move_and_slide(velocity, Vector2.UP) 
	var was_on_floor = is_on_floor()
	if is_on_floor():
		velocity.y = 170
func bounce():
	velocity.y = JUMPFORCE * 0.6
	



func ouch(var enemyposx):
	$Sprite.play("death")
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMPFORCE * 0.8
	if position.x < enemyposx:
		velocity.x = -800
	elif position.x > enemyposx:
		velocity.x = 800
	
	Input.action_release("left")
	Input.action_release("right")
	$Timer.start()
	


func _on_Timer_timeout():
	get_tree().change_scene("res://Level1.tscn")









func _on_void_body_entered(body):
	if body.is_in_group("players"):
		get_tree().change_scene("res://Level1.tscn")





onready var Coin1 = get_node("../Coin/Coin1")
onready var BreakableBlock = get_node("../BreakableBlock/BreakableBlock1")




func _on_Spike1_body_entered(body):
	if body.is_in_group("players"):
		set_modulate(Color(1,0.3,0.3,0.3))
		velocity.y = JUMPFORCE * 0.8
		
		Input.action_release("left")
		Input.action_release("right")
		$Timer.start()
		$Sprite.play("Fall")







func _on_BreakableBlock1_body_entered(body):
	if body.is_in_group("players"):
		BreakableBlock.broke()





onready var Coin2 = get_node("../Coin/Coin2")
onready var Coin3 = get_node("../Coin/Coin3")
onready var Coin6 = get_node("../Coin/Coin6")
onready var Coin5 = get_node("../Coin/Coin5")
onready var Coin4 = get_node("../Coin/Coin4")




func _on_Coin1_body_entered(body):
	if body.is_in_group("players"):
		Coin1.ded()


func _on_Coin2_body_entered(body):
	if body.is_in_group("players"):
		Coin2.ded()


func _on_Coin3_body_entered(body):
	if body.is_in_group("players"):
		Coin3.ded()


func _on_Coin6_body_entered(body):
	if body.is_in_group("players"):
		Coin6.ded()


func _on_Coin5_body_entered(body):
	if body.is_in_group("players"):
		Coin5.ded()


func _on_Coin4_body_entered(body):
	if body.is_in_group("players"):
		Coin4.ded()









