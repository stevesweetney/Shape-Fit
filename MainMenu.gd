extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$VBoxContainer/Play.grab_focus()


func on_quit():
	get_tree().quit()
	
func _on_Play_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_Tutorial_pressed():
	$WindowDialog.popup()
