extends KinematicBody2D

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
			$AnimatedSprite.play("Attacking")
			attacking = true
			$Weapon/CollisionShape2D.disabled = false
		#weapon.attack()
	if Input.is_action_just_pressed("ui_up"):
			velocity.y = -150
	if health <= 0:
		queue_free()
	velocity = move_and_slide(velocity)
	 
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Attacking":
		$Weapon/CollisionShape2D.disabled = true
		print(str(health))
	attacking = false
