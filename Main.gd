extends Node2D

var score = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func handle_score(val):
	score += val
	$HUD.update_score(score)



func _on_Map01_completed(score):
	handle_score(score)
