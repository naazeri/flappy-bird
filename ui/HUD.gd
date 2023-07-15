extends CanvasLayer

onready var scoreLabel := $Score


func updateScore(newScore):
	scoreLabel.text = str(newScore)
