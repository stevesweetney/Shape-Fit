extends Node2D

var look_at = Vector2(0,0)

func update_look_at(pos):
	$RightEye/inner_eye.look_at = pos
	$LeftEye/inner_eye2.look_at = pos
	
