extends Area2D

@export var plane : CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	if body == plane:
		body.game_over()
