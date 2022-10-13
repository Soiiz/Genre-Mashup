extends Area2D

func _on_BossMeleeHit_body_entered(body: Node) -> void:
	if _on_BossAnim_animation_finished():
		if body.has_method("boss_melee_hit"): 
			body.boss_melee_hit()
		


func _on_BossAnim_animation_finished():
	return 1
