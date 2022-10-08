extends KinematicBody2D

const bulletPath = preload('res://Bullet.tscn')

var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.y += 4
	if Input.is_action_pressed("ui_right"):
		velocity.x = 50
	elif Input.is_action_pressed("ui_left"):
			velocity.x = -50
	else: 
			velocity.x = 0

	if Input.is_action_just_pressed("ui_up"):
			velocity.y = -150
			
	velocity = move_and_slide(velocity)
	

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("im shooting")
		shoot()
	$Node2D.look_at(get_global_mouse_position())

func shoot():
	var bullet = bulletPath.instance()
	
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
	
	bullet.velocity = get_global_mouse_position() - bullet.position
