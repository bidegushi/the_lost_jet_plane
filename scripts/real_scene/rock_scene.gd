extends "res://scripts/real_scene/base_scene.gd"

@export var rock : PackedScene
@export var timer : Timer

var max_x : int = 4990
var max_y : int = 378
var min_x : int = -1406
var min_y : int = -47
var num_rock : int = 300


var game_time : int = 100 #本场游戏的时间 单位:s



func _ready() -> void:
	mode_name="陨石模式"
	mode=1
	startint_game()
	generate_rock() #生成石头
	
func _process(delta: float) -> void:
	if is_game_over==false:
		update_time_label()
		check_win()
	if plane.fuel_amount<=0.1 and plane.speed()<=0.1:
		await get_tree().create_timer(3)
		$LoseCanvasLayer/RetryButton.visible=true


func generate_rock()->void:
	for i in range(num_rock):
		var rock_node=rock.instantiate()
		var random_x=randf_range(min_x,max_x)
		var random_y=randf_range(min_y,max_y)
		rock_node.position=Vector2(random_x,random_y)
		add_child(rock_node)
		
#开始游戏时的流程
func startint_game()->void:
	$"CanvasLayer/时间内内逃离".text=str(game_time)+"s内逃离"
	$"CanvasLayer/时间内内逃离".visible=true
	await get_tree().create_timer(0.5).timeout
	$"CanvasLayer/时间内内逃离".visible=false
	
	$"CanvasLayer/开始!".visible=true
	await get_tree().create_timer(0.5).timeout
	$"CanvasLayer/开始!".visible=false
	
	timer.wait_time=game_time
	timer.start()
	plane.is_game_started=true

func update_time_label()->void:
	var time_str
	var time_num : int
	time_num=int(timer.time_left)
	var m
	var s
	s=time_num%60
	m=time_num/60
	time_str="%02d:%02d"%[m,s]
	$CanvasLayer/Time.text=time_str

func check_win()->void:
	if plane.position.x>5312:
		win()

func win()->void:
	cost_time=timer.time_left
	score=cost_time*10
	
	$CanvasLayer/Time.visible=false
	super.win()


func lose()->void:
	#cost_time=timer.wait_time-timer.time_left
	#score=cost_time*10
	
	super.lose()


func _on_倒计时_timeout() -> void:
	lose()
