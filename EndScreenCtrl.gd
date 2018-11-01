extends Control

func _ready():
	$RESET.grab_focus()

func _enter_tree():
	request_ready()
