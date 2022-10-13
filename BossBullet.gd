extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 3
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	look_vec = player.position - global_position
	
func _physics_process(delta):
	move = Vector2.ZERO
	
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move

func set_projectile_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true

func _on_BossBullet_body_entered(body):
	if body.has_method("boss_ranged_hit"):
		body.boss_ranged_hit()
	queue_free()
