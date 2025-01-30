extends Node2D

@export var plane : CharacterBody2D

@export var mode_name : String

@export var scoreboard : PackedScene=preload("res://scene/ui_component/scoreboard.tscn")

var is_game_over : bool = false

var mode:int=0
var cost_time:int
var score:int

func _ready() -> void:
	mode_name="普通模式"
	plane.is_game_started=true
	

func win()->void:
	plane.is_game_over=true
	is_game_over=true
	
	plane.jet_sound.stop()
	plane.shut_sound.stop()
	var scoreboard_node=scoreboard.instantiate()
	get_tree().current_scene.add_child(scoreboard_node)
	print("win")
	

func lose()->void:
	
	
	$"LoseCanvasLayer/游戏失败".visible=true
	$LoseCanvasLayer/RetryButton.visible=true
	print("lose")
	is_game_over=true
	plane.game_over()
	#var scoreboard_node=scoreboard.instantiate()
	#get_tree().current_scene.add_child(scoreboard_node)


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
