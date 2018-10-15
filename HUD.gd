extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$ScoreLabel.text = "0"

func update_score(score):
	$ScoreLabel.text = str(score)
