extends Control




func _on_开始游戏_pressed() -> void:
	SceneManager.change_scene("base_scene")


func _on_陨石模式_pressed() -> void:
	SceneManager.change_scene("rock_scene")
