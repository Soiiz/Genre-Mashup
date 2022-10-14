extends Area2D

const SPEED = 200
var velocity = Vector2()
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func set_projectile_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
#func _on_PlayerProjectile_body_entered(body):
#	if body == "Enemy":
#		body.dead() #kill enemy
#	queue_free()
#
#func _on_Weapon_body_entered(body: Node) -> void:
#	if body.has_method("handle_hit"):
#		body.handle_hit()



func _on_Bullet_body_entered(body):
	if body.has_method("ranged_hit"):
		$HitSound.play()
		body.ranged_hit()
	queue_free()
