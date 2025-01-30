extends CharacterBody2D

@export var spirte : AnimatedSprite2D
@export var ui_fuel_bar : TextureProgressBar
@export var explosion : PackedScene
@export var block_tile_layer : TileMapLayer

@export var jet_sound : AudioStreamPlayer
@export var shut_sound : AudioStreamPlayer

var rotation_speed: float = 10.0 #转向速度


@export var fuel_amount : float = 100 #燃油总量
var fuel_usage_rate : float = 2 #每秒消耗量
var propulsion_acceleration : float = 100 #推进的加速度
var zeta:float=25 #飞行中的阻尼的加速度

var is_game_started : bool = false
var is_game_over : bool = false



func _ready() -> void:
	ui_fuel_bar.max_value=fuel_amount #设定右上角燃料量进度条的最大值
	ui_fuel_bar.value=fuel_amount 
	block_tile_layer=$"../TileMapLayers/Blocks"
	
func _process(delta: float) -> void:

	pass
	

func _physics_process(delta: float) -> void:
	
	show_info()
	#check(delta)
	
	show_fuel(delta)
	show_speed()
	
	if not is_game_over and is_game_started:
		toward_mouse(delta)
		move(delta)
		damp(delta)
	

func game_over()->void:
	if is_game_over==false:

		is_game_over=true
		
		#停止音频
		jet_sound.stop()
		shut_sound.stop()
		
		#隐藏飞机精灵
		spirte.visible=false
		
		#产生爆炸效果
		var explosion_effect_node=explosion.instantiate()
		explosion_effect_node.position=position
		get_tree().current_scene.add_child(explosion_effect_node)
		await get_tree().create_timer(0.6).timeout
		explosion_effect_node.queue_free()
				
		
		
#实现指向鼠标
func toward_mouse(delta:float)->void:
	#实现指向鼠标
	#获取鼠标位置
	var mouse_position = get_global_mouse_position()
	#计算相对位置
	var direction = mouse_position - global_position
	var angle = direction.angle()
	rotation=lerp_angle(rotation,angle,rotation_speed*delta)
	#rotation = angle - get_parent().rotation
	#rotation=lerp_angle(rotation,angle - get_parent().rotation,rotation_speed*delta)

#用于控制一次停止后，只发出一次熄火声音
var has_shut_sound_played : bool = true

#实现移动
func move(delta:float)->void:
	#print(velocity.length())
	if Input.is_action_pressed("move_forward") and fuel_amount>0:
		#print("moveing")
		spirte.play("moving")
		fuel_amount-=fuel_usage_rate*delta
		var mouse_pos=get_global_mouse_position()
		var direction=(mouse_pos-position).normalized()
		velocity+=direction*propulsion_acceleration*delta
		
		has_shut_sound_played=false
		if not jet_sound.playing:
			jet_sound.play()
		if shut_sound.playing:
			shut_sound.stop()
	else:
		
		spirte.play("idle")
		if jet_sound.playing:
			jet_sound.stop()
		
		if not shut_sound.playing and not has_shut_sound_played:
			shut_sound.play()
			has_shut_sound_played=true
	
	move_and_slide()
	
	if fuel_amount<0: #为了避免燃料出现负值
		fuel_amount=0
		ui_fuel_bar.value=0 #修复有时上面的燃料进度条不能显示0的bug



#阻尼效果
func damp(delta:float)->void: 
	if velocity.length()>0:
		velocity-=velocity.normalized()*zeta*delta

#显示位置和剩余燃油量
func show_info()->void: 
	var label=$Label
	var pos_str=str(Vector2i(position))
	var fuel_str=str(fuel_amount)
	label.text=pos_str+'\n'+fuel_str
	label.rotation=-rotation

#右上角显示燃料
func show_fuel(delta : float)->void:
	ui_fuel_bar.value=lerp(ui_fuel_bar.value,fuel_amount,delta*5)
	$"CanvasLayer/剩余燃料/Label".text="剩余燃料: "+str(int(100*fuel_amount/ui_fuel_bar.max_value))+"%"

func speed()->float:#获取速率的函数
	return velocity.length()

#右上角显示速率
func show_speed()->void:
	$"CanvasLayer/当前速度".text="当前速率: "+str(int(speed()))

func check(delta:float)->void:
	pass
	#本来想用来实现碰到就炸，但是弄不了
	#var tile_data = block_tile_layer.get_cell_tile_data(position)
	#if tile_data!=null:
		#print("111")
		#var data=tile_data.get_custom_data("die")
		#if data==true:
			#print("222")
