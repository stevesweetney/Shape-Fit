extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Play.grab_focus()


func on_quit():
	print("quiting")
	get_tree().quit()
	
func _on_Play_pressed():
	get_tree().change_scene("res://Main.tscn")
