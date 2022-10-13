extends Area2D

func _on_Weapon_body_entered(body: Node) -> void:
	if body.has_method("melee_hit"):
		body.melee_hit()
		
