extends Node2D

onready var follow = $Path2D/PathFollow2D
onready var square = $Path2D/PathFollow2D/square
var rushing = false
var rushing_to = 0
var score = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Tween.interpolate_property(
		$transitionNode/TextureRect.get_material(), "shader_param/cutoff", 0.0, 
		1.0,  2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
func start_transition():
	var tex_rect = $transitionNode/TextureRect
	tex_rect.get_material().set_shader_param("cutoff", 0)
	tex_rect.cap_screen()
	tex_rect.show()
	$Map.hide()
	$Tween.start()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("left_click"):
		var space_state = get_world_2d().direct_space_state
		var all_in = true
		#print(square.polygon)
		for vertex in square.polygon:
			var global_vertex = square.global_position + vertex
			var shapes = space_state.intersect_point(global_vertex, 1)
			#print(shapes.size())
			if shapes.empty():
				all_in = false
		if all_in:
			score += 100
			$HUD.update_score(score)
			print("Inside square!")
			start_transition()

func _process(delta):
	$Eyes.update_look_at(square.global_position)
	if rushing:
		follow.set_offset(follow.get_offset() + 400 * delta)
		if follow.get_offset() > rushing_to:
			rushing = false
	else:
		follow.set_offset(follow.get_offset() + 200 * delta)
		if Input.is_action_just_pressed("ui_accept"):
			rushing = true
			rushing_to = follow.get_offset() + 200
		
