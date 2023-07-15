extends CanvasLayer

signal startGame

onready var gameOverMenu = $GameOverMenu
onready var startMessage = $StartMenu/StartMessage
onready var scoreLabel = $GameOverMenu/VBoxContainer/ScoreLabel
onready var highScoreLabel = $GameOverMenu/VBoxContainer/HighScoreLabel
onready var restartButton = $GameOverMenu/VBoxContainer/RestartButton
onready var tween = $Tween

var gameStarted := false


func _ready():
	restartButton.connect("pressed", self, "_on_RestartButton_pressed")
	startMessage.visible = true
	gameOverMenu.visible = false


func _input(event):
	if not gameStarted and event.is_action_pressed("flap"):
		emit_signal("startGame")

		# fade out startMessage
		tween.interpolate_property(startMessage, "modulate:a", 1, 0, 0.5)
		tween.start()

		gameStarted = true


func _on_RestartButton_pressed():
	# warning-ignore: return_value_discarded
	get_tree().reload_current_scene()


func showGameOverMenu(score, highscore):
	scoreLabel.text = str("SCORE: ", score)
	highScoreLabel.text = str("BEST: ", highscore)
	gameOverMenu.visible = true
