extends Area2D

func _on_Weapon_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit()
		
