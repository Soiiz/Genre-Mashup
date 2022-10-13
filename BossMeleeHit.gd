extends Area2D

func _on_BossMeleeHit_body_entered(body: Node) -> void:
	if body.has_method("boss_melee_hit") and _on_BossAnim_animation_finished():
		body.boss_melee_hit()
		


func _on_BossAnim_animation_finished():
	return 1
