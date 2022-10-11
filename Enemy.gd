extends KinematicBody2D


var player = null
var velocity = Vector2.ZERO
var MAX_SPEED = 40
var ACCELERATION = 10
onready var sprite = $Sprite
const GRAVITY = 200.0

enum {
	IDLE,
	ATTACK,
	CHASE
}
var state = IDLE

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, 15 * delta)
			seek_player()
		ATTACK:
			pass
		CHASE:
			if player != null:
				var direction = (player.global_position - global_position)
				direction.y = 0
				direction.normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0 # flips sprite depending on velocity which depends on player location
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
	#if body != self:
	player = body
	
func _on_PlayerDetectionZone_body_exited(body):
	player = null
