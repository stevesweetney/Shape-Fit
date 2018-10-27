extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"





func _on_Button_pressed():
	$ColorRect.cap_screen()
	$ColorRect3.hide()
	$ColorRect.show()
