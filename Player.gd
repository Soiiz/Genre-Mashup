extends KinematicBody2D

const bulletPath = preload('res://Bullet.tscn')

var velocity = Vector2.ZERO
var attacking = false
onready var position2D = $Position2D
onready var weapon = $Weapon
export (int) var health = 10

func _physics_process(delta):
	velocity.y += 4
	if Input.is_action_pressed("ui_right") && attacking == false:
		$AnimatedSprite.play("default")
		scale.x = scale.y * 1
		velocity.x = 50
	elif Input.is_action_pressed("ui_left") && attacking == false:
		$AnimatedSprite.play("default")
		scale.x = scale.y * -1
		velocity.x = -50
	else:
		velocity.x = 0
		if attacking == false:
			$AnimatedSprite.play("Idle")
	if Input.is_action_pressed("ui_accept"):
		if health < 50:
			$AnimatedSprite.play("Healing")
			attacking = true
			$Weapon/CollisionShape2D.disabled = false
		#weapon.attack()
	if is_on_floor() && Input.is_action_just_pressed("ui_up"):
			velocity.y = -150
	if health <= 0:
		queue_free()
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	 
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Healing":
		$Weapon/CollisionShape2D.disabled = true
		health += 10
		print(str(health))
	attacking = false

#func _process(delta):
#	if Input.is_action_just_pressed("ui_accept"):
#		print("im shooting")
#		shoot()
#	$Node2D.look_at(get_global_mouse_position())
#
#func shoot():
#	var bullet = bulletPath.instance()
#
#	get_parent().add_child(bullet)
#	bullet.position = $Node2D/Position2D.global_position
#
#	bullet.velocity = get_global_mouse_position() - bullet.position
