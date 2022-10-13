extends KinematicBody2D

const PROJECTILE = preload('res://Bullet.tscn')

enum {
STICK,
PIXEL,
CARTOON
}
var velocity = Vector2.ZERO
var pixelAttacking = false
var stickAttacking = false
var cartoonAttacking = false
const GRAVITY = 35
var onGround = false
onready var position2D = $Position2D
onready var weapon = $Weapon
export (int) var health = 100
var max_health = health

var state = STICK

func _physics_process(delta):
	if Input.is_action_just_pressed("num_1"):
		state = STICK
		print(str("Stick"))
	elif Input.is_action_just_pressed("num_2"):
		state = PIXEL
		print(str("Pixel"))
	elif Input.is_action_just_pressed("num_3"):
		state = CARTOON
		print(str("Cartoon"))
	state(state)

func state(state):
	match state:
		STICK:
			velocity.y += 4
			$PixelSpriteAnimation.visible = false
			$StickSpriteAnimation.visible = true
			$CartoonSpriteAnimation.visible = false
			if Input.is_action_pressed("ui_right") && stickAttacking == false:
				$StickSpriteAnimation.play("default")
				scale.x = scale.y * 1
				velocity.x = 100
			elif Input.is_action_pressed("ui_left") && stickAttacking == false:
				$StickSpriteAnimation.play("default")
				scale.x = scale.y * -1
				velocity.x = -50
			else:
				velocity.x = 0
				if stickAttacking == false:
					$StickSpriteAnimation.play("Idle")
			if Input.is_action_pressed("ui_accept"):
				$StickSpriteAnimation.play("Attacking")
				stickAttacking = true
				$Weapon/CollisionShape2D.disabled = false
			if is_on_floor() && Input.is_action_just_pressed("ui_up"):
				velocity.y = -200
			if health <= 0:
				queue_free()
			velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		CARTOON:
			velocity.y += 4
			$CartoonSpriteAnimation.visible = true
			$PixelSpriteAnimation.visible = false
			$StickSpriteAnimation.visible = false
			if Input.is_action_pressed("ui_right") && cartoonAttacking == false:
				velocity.x= 50
				if is_on_floor() == false:
					$CartoonSpriteAnimation.play("jump")
				else:
					$CartoonSpriteAnimation.play("walk");
					scale.x = scale.y * 1
					if sign($Position2D.scale.x) == -1:
						$Position2D.scale.x *= -1
			elif Input.is_action_pressed("ui_left") && cartoonAttacking == false:
				velocity.x = -50
				if is_on_floor() == false:
					$CartoonSpriteAnimation.play("jump")
				else:
					$CartoonSpriteAnimation.play("walk");
					scale.x = scale.y * -1
					if sign($Position2D.scale.x) == 1:
						$Position2D.scale.x *= -1
			else:
				velocity.x = 0
				if cartoonAttacking == false:
					$CartoonSpriteAnimation.play("idle");
			if is_on_floor() && Input.is_action_just_pressed("ui_up"):
				velocity.y = -200
			if Input.is_action_just_pressed("ui_accept") && cartoonAttacking == false:
				if is_on_floor():
					velocity.x = 0
				cartoonAttacking = true
				$CartoonSpriteAnimation.play("rangeAttack")
				var projectile = PROJECTILE.instance()
				if sign($Position2D.scale.x) == 1:
					projectile.set_projectile_direction(1) # fires projectile to right
				else:
					projectile.set_projectile_direction(-1) # fires to left
				get_parent().add_child(projectile)
				projectile.position = $Position2D.global_position
			if is_on_floor():
				if onGround == false:
					cartoonAttacking = false
				onGround = true
			else:
				if cartoonAttacking == false:
					onGround = false
					if velocity.y < 0:
						$CartoonSpriteAnimation.play("jump")
					else:
						$CartoonSpriteAnimation.stop()
			if health <= 0:
				queue_free()
			velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
			velocity.x = lerp(velocity.x,0,0.1)
		PIXEL:
			velocity.y += 4
			$PixelSpriteAnimation.visible = true
			$StickSpriteAnimation.visible = false
			$CartoonSpriteAnimation.visible = false
			if Input.is_action_pressed("ui_right") && pixelAttacking == false:
				$PixelSpriteAnimation.play("default")
				scale.x = scale.y * 1
				velocity.x = 50
			elif Input.is_action_pressed("ui_left") && pixelAttacking == false:
				$PixelSpriteAnimation.play("default")
				scale.x = scale.y * -1
				velocity.x = -50
			else:
				velocity.x = 0
				if pixelAttacking == false:
					$PixelSpriteAnimation.play("Idle")
			if Input.is_action_pressed("ui_accept"):
				if health < 100:
					$PixelSpriteAnimation.play("Healing")
					pixelAttacking = true
					$Weapon/CollisionShape2D.disabled = true
			if is_on_floor() && Input.is_action_just_pressed("ui_up"):
				velocity.y = -200
			if health <= 0:
				queue_free()
			velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
 
func _on_StickSpriteAnimation_animation_finished():
	if $StickSpriteAnimation.animation == "Attacking":
		$Weapon/CollisionShape2D.disabled = true
		print(str(health))
		print(str("hit"))
	stickAttacking = false

func _on_PixelSpriteAnimation_animation_finished():
	if $PixelSpriteAnimation.animation == "Healing":
		$Weapon/CollisionShape2D.disabled = true
		health += 5
		print(str(health))
		print(str("heal"))
	pixelAttacking = false

func _on_CartoonSpriteAnimation_animation_finished():
	print(str(health))
	print(str("pew"))
	cartoonAttacking = false
	
func boss_melee_hit():
	health -= 20
	$"/root/HpBar".set_percent_value_int(float(health)/max_health * 100)
	print(health)

func boss_ranged_hit():
	health -= 30
	$"/root/HpBar".set_percent_value_int(float(health)/max_health * 100)
	print(health)
