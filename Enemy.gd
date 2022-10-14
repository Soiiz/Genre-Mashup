extends KinematicBody2D

#TODO:
# add ranged damage
# healthbar

onready var BOSSBULLET_SCENE = preload("res://BossBullet.tscn")
const PROJECTILE = preload("res://BossBullet.tscn")

var player = null
var in_range = false
var velocity = Vector2.ZERO
var stopped = false
var MAX_SPEED = 20
var ACCELERATION = 25
const GRAVITY = 200.0
export (int) var max_health = 1000
onready var health = max_health setget _set_health
onready var currentanimation = $BossAnim
onready var timer = $Timer
onready var BossMeleeHit = $BossMeleeHit/Weapon

enum {
	RANGE,
	MELEE
}

enum {
	IDLE,
	ATTACK,
	CHASE
}
var state = IDLE
var attack_state = RANGE

func _physics_process(delta):
	$BossAnim.visible = true
	#if player is not in detection range, but uses ranged attack... aggro onto player
	if health < max_health and player == null:
		state = CHASE
	match state:
		IDLE:
			$BossAnim.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, 15 * delta)
			#seek_player()
		ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, 60 * delta)
			if(velocity == Vector2.ZERO):
				match attack_state:
					MELEE:
						$BossAnim.play("melee")
					RANGE:
						$BossAnim.play("ranged")
		CHASE:
			if timer.time_left > 0:
				stopped = false
			$BossAnim.play("walking")
			$PlayerDetectionZone/CollisionShape2D.scale *= 1.5
			if player != null:
				var direction = (player.global_position - global_position)
				direction.y = 0
				direction.normalized()
				if stopped == false:
					velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				else:
					velocity = velocity.move_toward(Vector2.ZERO, 50 * delta)
			else:
				state = IDLE
			#$BossAnim.flip_h = velocity.x >= 0 # flips sprite depending on velocity which depends on player location
			if velocity.x >= 0:
				scale.x = scale.y * -1
			else:
				scale.x = scale.y * 1
			
	velocity.y += delta * GRAVITY
	velocity = move_and_slide(velocity)

#func can_see_player():
#	return player != null
	
#func seek_player():
#	if can_see_player():
#		state = CHASE
	
func _on_PlayerDetectionZone_body_entered(body):
	if (body.name == "Player"):
		player = body
		state = CHASE

func melee_hit():
	_set_health(health - 100)
	print(health)
	
func ranged_hit():
	_set_health(health - 50)
	print(health)

func kill():
	get_tree().change_scene("res://Menu.tscn")
	queue_free()
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		if health == 0:
			kill()

func fire():
	var bullet = BOSSBULLET_SCENE.instance()
	if player.position.x - self.position.x > 0:
		bullet.set_projectile_direction(1) # fires projectile to right
	else:
		bullet.set_projectile_direction(-1) # fires projectile to left
	bullet.position = $Position2D2.global_position
	bullet.player = player
	get_parent().add_child(bullet)
	



func _on_MeleeRange_body_entered(body):
	if (body.name == "Player"):
		state = ATTACK
		attack_state = MELEE
		timer.stop()


func _on_MeleeRange_body_exited(body):
	if (body.name == "Player"):
		state = CHASE
		timer.start()


func _on_BossMeleeHit_body_entered(body):
	in_range = true


func _on_BossMeleeHit_body_exited(body):
	in_range = false


func _on_BossAnim_animation_finished():
	if currentanimation.get_animation() == "melee":
		if in_range == true:
			if player != null and player.has_method("boss_melee_hit"): 
				player.boss_melee_hit()
	elif currentanimation.get_animation() == "ranged":
		if player != null:
			fire()
			state = CHASE

func _on_Timer_timeout():
	print("works")
	state = ATTACK
	attack_state = RANGE
	
