extends Node

const start_scene = preload("res://scene/real_scene/start_page.tscn")

var base_scene = preload("res://scene/real_scene/base_scene.tscn")

var rock_scene = preload("res://scene/real_scene/rock_scene.tscn")



func change_scene(scene_name:String) ->void:
	var scene_to_load
	match scene_name:
		"start_page":
			scene_to_load=start_scene
		"base_scene":
			scene_to_load=base_scene	
		"rock_scene":
			scene_to_load=rock_scene	
	if scene_to_load != null :
		get_tree().change_scene_to_packed(scene_to_load)

#func change_to_main(plane_name:String) -> void:
	#var scene_to_load
	#scene_to_load=main_scene.instantiate()
	#
	#match plane_name:
		#"plane":
			#Global.plane_scene=load("res://scene/plane/plane.tscn")
		#"vip_plane":
			#Global.plane_scene=load("res://scene/plane/vip_plane.tscn")
		#"blue_plane":
			#Global.plane_scene=load("res://scene/plane/blue_plane.tscn")
	#change_scene("main")
