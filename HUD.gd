extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$ScoreLabel.text = "0"
	update_best(get_node("/root/globals").best_score)

func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_best(score):
	$BestScoreLabel.text = "Best: %s" % str(score)
	
func hide_score():
	$ScoreLabel.hide()
	
func show_score():
	$ScoreLabel.show()
