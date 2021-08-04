extends KinematicBody2D







var jump_timer = 0
var velocity = Vector2()
const SHORTHOP = -600
export var SPEED = 0
var JUMPFORCE = -1230
var GRAVITY = 40
export var MAXSPEED = 450
var sprint = 0
var friction = 0.8
var accel = 0.1
onready var coyote = $Coyote
var can_jump = true
var INPUT = true
var ANIM = true
var is_jumping = false
var was_on_floor = is_on_floor()
var runtime = 0
var direction = 0
var shroom = true
onready var Coin2 = get_node("../Coin/Coin2")
onready var Coin3 = get_node("../Coin/Coin3")
onready var Coin6 = get_node("../Coin/Coin6")
onready var Coin5 = get_node("../Coin/Coin5")
onready var Coin4 = get_node("../Coin/Coin4")
onready var Coin7 = get_node("../Coin/Coin7")
onready var Coin8 = get_node("../Coin/Coin8")




func jump_cut():
	if velocity.y < -600:
		velocity.y = -600
	if velocity.y < -450:
		velocity.y = -450

	
func input(delta):
	if INPUT:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene("res://Level1.tscn")
		var timedict = OS.get_time()
		var hour = timedict.hour;
	
	
		if Input.is_action_just_pressed("jump"):
			if can_jump:
				is_jumping = true
				velocity.y = JUMPFORCE + GRAVITY
				$Jumpsfx.play()
			if not is_on_floor():
				$Buffer.start()
		if Input.is_action_pressed("right"):
			SPEED = 350
			direction = 1
		if not Input.is_action_pressed("right") and SPEED > 0:
			
			SPEED = -50
			
		if Input.is_action_just_released("jump"):
			jump_cut()
			velocity.y = lerp(velocity.y, JUMPFORCE, 0.1) + GRAVITY * delta
		if Input.is_action_pressed("left"):
			SPEED = -350
			direction = -1
		if not Input.is_action_pressed("left") and SPEED < 0:
			SPEED += 50
		if Input.is_action_pressed("Run") and Input.is_action_pressed("right"):
			sprint = 200
			velocity.x = lerp(velocity.x, velocity.x + sprint, 0.05)
		if Input.is_action_pressed("Run") and Input.is_action_pressed("left"):
			sprint = -200
			velocity.x = lerp(velocity.x, velocity.x + -162, 0.08)
			if velocity.x < -512:
				velocity.x = -512
		if Input.is_action_pressed("Run") and not is_on_floor() and Input.is_action_pressed("right"):
			if velocity.y > 0:
				GRAVITY = 55
			velocity.y = velocity.y + -5
			SPEED = SPEED + 15
		if Input.is_action_pressed("Run") and not Input.is_action_pressed("right"):
			sprint = 0
		if Input.is_action_pressed("Run") and not Input.is_action_pressed("left"):
			sprint = 0
		if Input.is_action_just_released("right"):
			velocity.x = lerp(velocity.x, 0, friction)
		if Input.is_action_just_released("left"):
			velocity.x = lerp(velocity.x, 0, friction)
func Animation():
	if ANIM:
		if Input.is_action_pressed("right"):
			$Sprite.play("Walk")
			$Sprite.flip_h = true
			if shroom == true:
				$Sprite.play("bigwalk")
				$Sprite.flip_h = true
		if Input.is_action_pressed("left"):
			$Sprite.play("Walk")
			$Sprite.flip_h = false
			if shroom == true:
				$Sprite.play("bigwalk")
		if not Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
			$Sprite.play("idle")
			if shroom == true:
				$Sprite.play("bigidle")
		if not is_on_floor():
			$Sprite.play("Air")
			if shroom == true:
				$Sprite.play("bigair")
		if Input.is_action_pressed("Run") and Input.is_action_pressed("right") and is_on_floor() or Input.is_action_pressed("Run") and Input.is_action_pressed("left") and is_on_floor():
			$Sprite.set_speed_scale(2)
		else:
			$Sprite.set_speed_scale(1)
	
func _physics_process(delta):
	input(delta)
	Animation()
	move_and_slide(velocity, Vector2.UP)
	print("test")
	#monke banana
	if velocity.x > 450:
		friction = -0.2
	if is_on_ceiling():
		velocity.y = 25
	if velocity.x > 0 and is_on_floor():
		$Sprite.play("walk")
	if not is_on_floor():
		can_jump = false
		$CollisionShape2D.shape.extents = Vector2(23, 36.5)
		if velocity.y > 0:
			GRAVITY = 55
			$Sprite.play("Fall")
		velocity.y += GRAVITY
		friction = 0.4
		coyote.start()
	velocity.x = lerp(velocity.x, SPEED, accel) + sprint
	var was_on_floor = is_on_floor()
	if is_on_floor():
		velocity.y = 170
		can_jump = true
		$CollisionShape2D.shape.extents = Vector2(22, 34.2)
		friction = 0.5
	if GRAVITY < 40:
		GRAVITY = 40
	if not is_on_floor() and was_on_floor and not is_jumping:
		coyote.start()
		velocity.y = 0
		can_jump = true
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

func _on_Coin8_body_entered(body):
	if body.is_in_group("players"):
		Coin8.ded()




onready var Timer2 = get_node("../GOALPOST/Area2D/Timer2")
onready var CourseClear = get_node("../GOALPOST/Area2D/CourseClear")
onready var IMOUT = get_node("../GOALPOST/Area2D/IMOUT")
onready var music = get_node("../music")
onready var level = get_node("../../Level1")
onready var background = get_node("../Background")
onready var tiles = get_node("../TileMap")
onready var coloor = get_node("../ColorRect")
onready var goal = get_node("../GOALPOST/")
onready var Timer3 = get_node("../GOALPOST/Area2D/Timer3")
onready var Timer4 = get_node("../GOALPOST/Area2D/Timer4")
onready var Timer5 = get_node("../GOALPOST/Area2D/Timer5")
onready var clear = get_node("../LABELS/CLEAR")
func _on_Area2D_body_entered(body):
	if body.is_in_group("players"):
		clear.visible = true
		INPUT = false
		ANIM = false
		background.set_modulate(lerp(get_modulate(), Color(0,0,0,1), 1))
		tiles.set_modulate(lerp(get_modulate(), Color(0,0,0,1), 1))
		coloor.set_modulate(lerp(get_modulate(), Color(0,0,0,1), 1))
		goal.set_modulate(lerp(get_modulate(), Color(0,0,0,1), 1))
		Timer2.start()
		Timer3.start()
		Timer4.start()
		Timer5.start()
		CourseClear.play()
		music.stop()
		$Sprite.set_speed_scale(1)
		

func _on_Timer2_timeout():
	get_tree().change_scene("res://Level2.tscn")


func _on_Timer3_timeout():
	IMOUT.play()
	set_modulate(lerp(get_modulate(), Color(0,0,0,0.5), 1))


func _on_Timer4_timeout():
	CourseClear.stop()




func _on_Coyote_timeout():
	velocity.y += GRAVITY
	can_jump = false


func _on_Timer5_timeout():
	$Sprite.play("VICTORY")


func _on_Bullet1_body_entered(body):
	if body.is_in_group("players"):
		set_modulate(Color(1,0.3,0.3,0.3))
		velocity.y = JUMPFORCE * 0.8
		
		Input.action_release("left")
		Input.action_release("right")
		$KILL.start()
		$Sprite.play("Fall")


func _on_KILL_timeout():
	get_tree().change_scene("res://Level1.tscn")





func _on_Coin7_body_entered(body):
	if body.is_in_group("players"):
		Coin7.ded()



