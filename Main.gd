extends Node

var score = 0
var animated_score = 0
var maps = [preload("res://maps/Map01.tscn"), preload("res://maps/Map02.tscn"), preload("res://maps/Map03.tscn")]
var active_map = 0
var reset = false
var prev = null
var curr = null
var end_screen = preload("res://EndGame.tscn").instance()
var explosion_fx = preload("res://Explosion.tscn")
onready var globals = get_node("/root/globals")
var cam_trauma = 0
var MAX_ANGLE = 10 # angle in degs
var MAX_OFFSET = 10
onready var norm_cam_angle = $Cam.rotation_degrees

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_M:
		if $BGMusic.is_playing():
			$BGMusic.stop()
		elif not $BGMusic.is_playing():
			$BGMusic.play()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	globals.load_game()
	$HUD.update_best(globals.best_score)
	start()
	
func connect_map_signals(map_to_connect):
	map_to_connect.connect("completed", self, "_on_map_completed")
	map_to_connect.connect("loss", self, "_on_map_loss")
	map_to_connect.connect("hit_area", self, "_on_area_hit")
	map_to_connect.connect("close_miss", self, "_on_area_miss")
	
func disconnect_map_signals(map_to_disconnect):
	map_to_disconnect.disconnect("completed", self, "_on_map_completed")
	map_to_disconnect.disconnect("loss", self, "_on_map_loss")
	map_to_disconnect.disconnect("hit_area", self, "_on_area_hit")
	map_to_disconnect.disconnect("close_miss", self, "_on_area_miss")
	
func start():
	curr = maps[active_map].instance()
	add_child(curr)
	
	if not curr.is_connected("completed", self, "_on_map_completed"):
		connect_map_signals(curr)
	var reset_button = end_screen.get_node("EndScreenCtrl/RESET")
	var back_button = end_screen.get_node("EndScreenCtrl/BACK")
	if not reset_button.is_connected("pressed", self, "reset_game"):
		reset_button.connect("pressed", self, "reset_game")
	if not back_button.is_connected("pressed", self, "go_to_main_menu"):
		back_button.connect("pressed", self, "go_to_main_menu")
		
	curr.active = true
	if not $BGMusic.playing:
		$BGMusic.play()
	else:
		$AnimTransition.interpolate_property(
			$BGMusic, "volume_db", $BGMusic.get_volume_db(), 0, 1.0, 
			Tween.TRANS_QUAD, Tween.EASE_IN)
	
func _process(delta):
	$HUD.update_score(round(animated_score))
	var shake = cam_trauma * cam_trauma
	var offsetX = MAX_OFFSET * shake * rand_range(-1, 1)
	var offsetY = MAX_OFFSET * shake * rand_range(-1, 1)
	var angle = MAX_ANGLE * shake * rand_range(-1,1)
	cam_trauma -= .2 * delta
	cam_trauma = max(0, cam_trauma)
	$Cam.set_rotation_degrees(norm_cam_angle + angle)
	$Cam.set_offset(Vector2(offsetX, offsetY))
	
func handle_score(val):
	score += val
	$HUD.update_gain(val)
	$AnimTransition.interpolate_property(
		self, "animated_score", animated_score, score, 1.8, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	$AnimTransition.interpolate_property(
		$HUD/ScoreLabel/Gain, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1.8, 
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	if not $AnimTransition.is_active():
		$AnimTransition.start() 
	
func start_transition():
	$AnimTransition.interpolate_property(
		$Transition.get_material(), "shader_param/cutoff", 0.0, 
		1.0,  1.0, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Transition.get_material().set_shader_param("cutoff", 0)
	$HUD.hide_score()
	$Transition.cap_screen()
	$HUD.show_score()
	prev = curr
	curr = maps[active_map].instance()
	add_child(curr)
	remove_child(prev)
	prev.queue_free()
#	var position_p = curr.get_position_in_parent()
#	move_child($Transition, position_p)
	$Transition.raise()
	if not $AnimTransition.is_active():
		$AnimTransition.start()
	
func _on_map_completed(score):
	handle_score(score)
	disconnect_map_signals(curr)
	if active_map + 1 == maps.size():
		shuffle(maps)
		active_map = 0
	else:
		active_map += 1
	#add_child(maps[active_map+1])
	start_transition() # start transition effect and change current map
	while yield($AnimTransition, "tween_completed")[0] != $Transition.get_material():
		pass
	connect_map_signals(curr)
	curr.active = true
	
func _on_map_loss():
	curr.active = false
	#$BGMusic.stop()
	if $BGMusic.playing:
		$AnimTransition.interpolate_property(
			$BGMusic, "volume_db", $BGMusic.get_volume_db(), -30, 1.0, 
			Tween.TRANS_QUAD, Tween.EASE_IN)
		$AnimTransition.start()
	#print("score: %s best: %s" % [score, globals.best_score])
	globals.best_score = max(score, globals.best_score)
	globals.save_game()
	$HUD.update_best(globals.best_score)
	add_child(end_screen)
	print("You lose!")
	
func _on_area_hit(pos):
	var e = explosion_fx.instance()
	e.global_position = pos
	add_child(e)
	e.start()
	cam_trauma += .15
	$area_hit_sfx.play()
	
func _on_area_miss():
	$area_miss_sfx.play()
	cam_trauma += .32
	
func shuffle(arr):
	var i  = arr.size() - 1;
	while i >= 1:
		var j = randi() % (i+1)
		var temp = arr[j]
		arr[j] = arr[i]
		arr[i] = temp
		i -= 1
		
func go_to_main_menu():
	get_tree().change_scene("res://MainMenu.tscn")
	
func reset_game():
	call_deferred("_deferred_reset_game")
	
func _deferred_reset_game():
	remove_child(end_screen)
	active_map = 0
	score = 0
	animated_score = 0
	$HUD.update_score(score)
	prev = null
	shuffle(maps)
	remove_child(curr)
	curr.free()
	start()
	
	
