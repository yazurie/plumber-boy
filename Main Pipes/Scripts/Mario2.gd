extends Sprite

onready var ray = get_node("RayCast2D")
var speed = 256
var tile_size = 64
var last_position = Vector2()
var target_position = Vector2()
var movedir = Vector2() #direction


func _ready():
	position = position.snapped(Vector2(tile_size, tile_size)) # make sure player is snapped to 64 x 64 so that he can't be in between a tile
	last_position = position
	target_position = position

func _process(delta):
	#MOVEMENT SECTION START
	if ray.is_colliding(): # if player hits wall he gets snapped back to where he was before
		position = last_position
		target_position = last_position
	else:
		position += speed * movedir * delta #if we are not at target position get moving boy
		if position.distance_to(last_position) >= tile_size - speed * delta: #if we move more pixels than intended we get snapped back to our target position
			position = target_position
	
	#MOVEMENT SECTION END
	
	
	#IDLE SECTION START
	if position == target_position: #if we are idle
		get_movedir() #only check for movement if we are idle
		last_position = position
		target_position += movedir * tile_size #64 pixels in the direction pressed is our target position
	#IDLE SECTION END



func get_movedir(): #input function
	var LEFT = Input.is_action_just_pressed("left")
	var RIGHT = Input.is_action_just_pressed("right")
	var UP = Input.is_action_just_pressed("ui_up")
	var DOWN = Input.is_action_just_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT) #if left is pressed direction is -1 if both are pressed direction = 0 if only right is pressed direction = 1
	movedir.y = -int(UP) + int(DOWN) #same as above
	
	if movedir.x != 0 && movedir.y != 0: #make sure the player doesn't move diagonally
		movedir = Vector2.ZERO #same as Vector2(0,0) use whatever you want
	
	if movedir != Vector2.ZERO: #if player is moving we cast the ray right to the boundaries of the player
		ray.cast_to = movedir * tile_size / 2
