extends KinematicBody2D


var player = null
var velocity = Vector2.ZERO
var MAX_SPEED = 40
var ACCELERATION = 10
const GRAVITY = 200.0
export (int) var max_health = 1000
onready var health = max_health setget _set_health

enum {
	IDLE,
	ATTACK,
	CHASE
}
var state = IDLE

func _physics_process(delta):
	$BossAnim.visible = true
	match state:
		IDLE:
			$BossAnim.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, 15 * delta)
			seek_player()
		ATTACK:
			pass
		CHASE:
			print("boss chase")
		
			$BossAnim.play("walking")
			$PlayerDetectionZone/CollisionShape2D.scale *= 1.5
			if player != null:
				var direction = (player.global_position - global_position)
				direction.y = 0
				direction.normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				print(velocity)
			else:
				state = IDLE
			$BossAnim.flip_h = velocity.x > 0 # flips sprite depending on velocity which depends on player location
	velocity.y += delta * GRAVITY
	velocity = move_and_slide(velocity)

func can_see_player():
	return player != null
	
func seek_player():
	if can_see_player():
		state = CHASE
	
func _on_Timer_timeout():
	pass # Replace with function body.
	
func _on_PlayerDetectionZone_body_entered(body):
	if (body.name == "Player"):
		player = body
	
func _on_PlayerDetectionZone_body_exited(body):
	player = null

func melee_hit():
	_set_health(health - 100)
	print(health)
	
func ranged_hit():
	_set_health(health - 50)
	print(health)

func kill():
	queue_free()
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		if health == 0:
			kill()
