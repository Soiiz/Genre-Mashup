extends KinematicBody2D


var player = null
var velocity = Vector2.ZERO
var speed = 100

#const GRAVITY = 32
#const UP = Vector2.UP

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if player != null:
		if player.position.x < self.position.x:
			velocity.x = -35
		elif player.position.x > self.position.x:
			velocity.x = 35
		#velocity = position.direction_to(player.position) * speed
		#velocity.y = 0
		
	else:
		velocity = Vector2.ZERO
		
	#velocity = velocity.normalized()
	#velocity = move_and_collide(velocity)
	velocity = move_and_slide(velocity)
	
func _on_Area2D_body_entered(body):
	if body != self:
		player = body
		


func _on_Timer_timeout():
	pass # Replace with function body.
	
#func move():
#	velocity.y += GRAVITY
#	velocity.x = -speed
	#velocity = move_and_slide(velocity, UP)
