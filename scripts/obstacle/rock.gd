extends RigidBody2D

var max_impact_speed : float = 100 #最大撞击速率


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("boom"):
		queue_free()



#速率超过最大撞击速率，则飞机爆炸
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("plane"):
		if body.speed()>max_impact_speed:
			get_tree().current_scene.lose()
