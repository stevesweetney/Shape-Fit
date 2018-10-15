extends KinematicBody2D


var velocity = Vector2()
var MAX_SPEED = 200;

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func process_input():
	if  Input.is_action_pressed("ui_right"):
		velocity.x += 10
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 10
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 10
	if Input.is_action_pressed("ui_down"):
		velocity.y += 10
	velocity = velocity.clamped(MAX_SPEED)

func _process(delta):
	process_input()
	velocity = velocity * 0.98;
	move_and_slide(velocity)
