extends KinematicBody2D







var jump_timer = 0
var velocity = Vector2()
const SHORTHOP = -600
export var SPEED = 0
var JUMPFORCE = -1230
var GRAVITY = 40
export var MAXSPEED = 450
var sprint = 0
var friction = 0.45
var accel = 0.1
onready var coyote = $Coyote
var can_jump = true
var INPUT = true
var ANIM = true
var is_jumping = false
var was_on_floor = is_on_floor()
var runtime = 0
var direction = 0
var goals = 0
var shroom = false
var run = false
var running = false
var right = false
var left = false

onready var shrooom = get_node("../Mushrooms/Mushroom1")
onready var player = get_node("../Player")
onready var collision = get_node("CollisionShape2D")
onready var sprite = get_node("Sprite")
onready var bigco = get_node("bigco")
onready var kill = get_node("KILL")
onready var jumpsfx = get_node("Jumpsfx")
onready var pipesfx = get_node("pipesfx")
onready var buffer = get_node("Buffer")
onready var pipe = get_node("pipe")
onready var timer = get_node("Timer")


func _on_Mushroom1_body_entered(body):
	if body.is_in_group("players"):
		shroom = true
		shrooom.queue_free()
		pipesfx.play()
		player.scale.x = 1.15
		player.scale.y = 1.15
func jump_cut():
	if velocity.y < -600:
		velocity.y = -600
	if velocity.y < -450:
		velocity.y = -450
	
func input(delta):
	if INPUT:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene("res://Scenes//Level1.tscn")
		var timedict = OS.get_time()
		var hour = timedict.hour;
		if Input.is_action_just_pressed("jump"):
			if can_jump:
				is_jumping = true
				velocity.y = JUMPFORCE + GRAVITY
				jumpsfx.play()
			if not is_on_floor():
				buffer.start()
		if Input.is_action_pressed("right"):
			SPEED = 400
			direction = 1
			right = true
		if Input.is_action_just_released("right"):
			SPEED = 0
			right = false
			
			
		if Input.is_action_just_released("jump"):
			jump_cut()
			velocity.y = lerp(velocity.y, JUMPFORCE, 0.1) + GRAVITY * delta
		if Input.is_action_pressed("left"):
			SPEED = -400
			direction = -1
			left = true
		if not Input.is_action_pressed("left") and SPEED < 0:
			SPEED += 50
		if Input.is_action_pressed("Run") and Input.is_action_pressed("right"):
			JUMPFORCE = -1400
			sprint = 200
			velocity.x = lerp(velocity.x, velocity.x + sprint, 0.05)
			runtime = OS.get_ticks_msec()
			running = true
		if Input.is_action_pressed("Run") and Input.is_action_pressed("left"):
			JUMPFORCE = -1400
			sprint = -200
			velocity.x = lerp(velocity.x, velocity.x + -162, 0.08)
			runtime = OS.get_ticks_msec()
			running = true
			if velocity.x < -512:
				velocity.x = -512
		if Input.is_action_pressed("Run") and not Input.is_action_pressed("right"):
			sprint = 0
		if Input.is_action_pressed("Run") and not Input.is_action_pressed("left"):
			sprint = 0
		if Input.is_action_just_released("Run"):
			JUMPFORCE = -1230
			runtime = 0
			running = false
			sprite.stop()
		if Input.is_action_just_released("right"):
			velocity.x = lerp(velocity.x, 0, friction)
			runtime = 0
			running = false
			sprite.stop()
			right = false
		if Input.is_action_just_released("left"):
			velocity.x = lerp(velocity.x, 0, friction)
			runtime = 0
			running = false
			sprite.stop()
			left = false
func Animation():
	if ANIM:
		if is_on_floor():
			if running == true:
				sprite.set_speed_scale(1.6)
			else:
				sprite.set_speed_scale(1)
			if shroom == false:
				if right == false and left == false:
					sprite.play("idle")
				if right == true:
					sprite.play("Walk")
					sprite.flip_h = true
				if left == true:
					sprite.play("Walk")
					sprite.flip_h = false
			if shroom == true:
				if right == false and left == false:
					sprite.play("bigidle")
				if right == true:
					sprite.play("bigwalk")
					sprite.flip_h = true
				if left == true:
					sprite.play("bigwalk")
					sprite.flip_h
		if not is_on_floor():
			if shroom == false:
				sprite.play("Air")
			if shroom == true:
				sprite.play("bigair")
			if left == true:
				sprite.flip_h = false
			if right == true:
				sprite.flip_h = true
func _physics_process(delta):
	input(delta)
	Animation()
	move_and_slide(velocity, Vector2.UP) 
	print (runtime)
	if runtime >= 5000:
		running = true
	if velocity.x > 500:
		velocity.x = 500
	if velocity.x < -500:
		velocity.x = -500
	if shroom == true:
		bigco.disabled = false
	if velocity.x > 450:
		friction = 0.2
	if is_on_ceiling():
		velocity.y = 25
	if not is_on_floor():
		can_jump = false
		if shroom == false:
			collision.shape.extents = Vector2(23, 36.5)
		if shroom == true:
			bigco.shape.extents = Vector2(23, 43)
		if velocity.y > 0:
			GRAVITY = lerp(GRAVITY, 55, 0.5)
			if shroom == false:
				sprite.play("Fall")
			if shroom == true:
				sprite.play("bigfall")
		velocity.y += GRAVITY
		friction = 0.4
		coyote.start()
	velocity.x = lerp(velocity.x, SPEED, accel) + sprint
	var was_on_floor = is_on_floor()
	if is_on_floor():
		velocity.y = 170
		can_jump = true
		collision.shape.extents = Vector2(22, 34.2)
		bigco.shape.extents = Vector2(22.2505, 41.488098)
		friction = 0.8
	if GRAVITY < 40:
		GRAVITY = 40
	if not is_on_floor() and was_on_floor and not is_jumping:
		coyote.start()
		velocity.y = 0
		can_jump = true
func bounce():
	velocity.y = JUMPFORCE * 0.6
	



func ouch(var enemyposx):
	sprite.play("death")
	set_modulate(Color(1,0.3,0.3,0.3))
	velocity.y = JUMPFORCE * 0.8
	if position.x < enemyposx:
		velocity.x = -800
	elif position.x > enemyposx:
		velocity.x = 800
	
	Input.action_release("left")
	Input.action_release("right")
	timer.start()
	


func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes//Level1.tscn")


func _on_void_body_entered(body):
	if body.is_in_group("players"):
		get_tree().change_scene("res://Level1.tscn")


onready var Coin1 = get_node("../Coin/Coin1")


func _on_Spike1_body_entered(body):
	if body.is_in_group("players"):
		set_modulate(Color(1,0.3,0.3,0.3))
		velocity.y = JUMPFORCE * 0.8
		
		Input.action_release("left")
		Input.action_release("right")
		timer.start()
		sprite.play("Fall")












#GOALPOST START

onready var Timer2 = get_node("../GOALPOST/Area2D/Timer2")
onready var CourseClear = get_node("../GOALPOST/Area2D/CourseClear")
onready var IMOUT = get_node("../GOALPOST/Area2D/IMOUT")
onready var music = get_node("../music")
onready var level = get_node("../../Level1")
onready var tiles = get_node("../TileMap")
onready var coloor = get_node("../ColorRect")
onready var goal = get_node("../GOALPOST/")
onready var Timer3 = get_node("../GOALPOST/Area2D/Timer3")
onready var Timer4 = get_node("../GOALPOST/Area2D/Timer4")
onready var Timer5 = get_node("../GOALPOST/Area2D/Timer5")
onready var clear = get_node("../LABELS/CLEAR")
func _on_Area2D_body_entered(body):
	if body.is_in_group("players"):
		goals = goals + 1
		clear.visible = true
		INPUT = false
		ANIM = false
		tiles.set_modulate(lerp(get_modulate(), Color(0,0,0,1), 1))
		coloor.set_modulate(lerp(get_modulate(), Color(0,0,0,1), 1))
		goal.set_modulate(lerp(get_modulate(), Color(0,0,0,1), 1))
		Timer2.start()
		Timer3.start()
		Timer4.start()
		Timer5.start()
		CourseClear.play()
		music.stop()
		sprite.set_speed_scale(1)
		

func _on_Timer2_timeout():
	get_tree().change_scene("res://Main.tscn")


func _on_Timer3_timeout():
	IMOUT.play()
	set_modulate(lerp(get_modulate(), Color(0,0,0,5), 1))


func _on_Timer4_timeout():
	CourseClear.stop()




func _on_Coyote_timeout():
	velocity.y += GRAVITY
	can_jump = false


func _on_Timer5_timeout():
	if shroom == false:
		sprite.play("idle")
	if shroom == true: 
		sprite.play("bigvictory")
#GOALPOST DONE


func _on_Bullet1_body_entered(body):
	if body.is_in_group("players"):
		set_modulate(Color(1,0.3,0.3,0.3))
		velocity.y = JUMPFORCE * 0.8
		
		Input.action_release("left")
		Input.action_release("right")
		kill.start()
		sprite.play("Fall")


func _on_KILL_timeout():
	get_tree().change_scene("res://Level1.tscn")









#new coin shit

func _on_body_entered(body):
	if body.is_in_group("coins"):
		body.ded()



