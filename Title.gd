extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play("Fade")
	yield(get_tree().create_timer(5), "timeout")
	$AnimationPlayer.play_backwards("Fade")
	yield(get_tree().create_timer(3), "timeout")
	get_tree().change_scene("res://Menu.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
