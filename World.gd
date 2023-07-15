extends Node2D

onready var hud = $HUD
onready var menuLayer = $MenuLayer
onready var obstacleSpawner = $ObstacleSpawner
onready var groundDeadZone = $Ground/DeadZone
onready var groundAnimationPlayer = $Ground/AnimationPlayer
onready var backgroundAnimationPlayer = $Background/AnimationPlayer
onready var player = $Player
onready var hitAudioPlayer = $HitAudioPlayer
onready var dieAudioPlayer = $DieAudioPlayer
onready var scoreAudioPlayer = $ScoreAudioPlayer

const SAVE_FILE_PATH = "user://savedata.save"

var score := 0 setget setScore
var highscore = 0
var gameStarted := false


func _ready():
	obstacleSpawner.connect("onObstacleSpawned", self, "_on_Obstacle_spawned")
	groundDeadZone.connect("body_entered", self, "_on_DeadZone_body_entered")
	menuLayer.connect("startGame", self, "_on_MenuLayer_startGame")
	player.connect("died", self, "_on_Player_died")
	loadHighscore()


func _on_MenuLayer_startGame():
	newGame()


func onGetScore():
	if not gameStarted:
		return

	self.score += 1
	scoreAudioPlayer.play()


func _on_Obstacle_spawned(obstacle):
	obstacle.connect("score", self, "onGetScore")


func _on_DeadZone_body_entered(body):
	if body is Player:
		var b: Player = body
		if b.has_method("die"):
			b.die()


func _on_Player_died():
	hitAudioPlayer.play()
	dieAudioPlayer.play()
	gameOver()


func _unhandled_input(event):
	handleExitGame(event)


func newGame():
	gameStarted = true
	self.score = 0
	obstacleSpawner.start()


func setScore(newScore):
	score = newScore
	hud.updateScore(score)


func gameOver():
	gameStarted = false
	obstacleSpawner.stop()
	groundAnimationPlayer.stop()
	backgroundAnimationPlayer.stop()
	get_tree().call_group("obstacles", "set_physics_process", false)  # disable all obstacles(pipes)

	if score > highscore:
		highscore = score
		saveHighscore()

	menuLayer.showGameOverMenu(score, highscore)


func saveHighscore():
	var saveData := File.new()
	var isOpened := saveData.open(SAVE_FILE_PATH, File.WRITE)
	if isOpened == OK:
		saveData.store_var(highscore)
		saveData.close()


func loadHighscore():
	var saveData := File.new()

	if saveData.file_exists(SAVE_FILE_PATH):
		var isOpened := saveData.open(SAVE_FILE_PATH, File.READ)
		if isOpened == OK:
			highscore = saveData.get_var()
			saveData.close()


func handleExitGame(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE and event.pressed:
		get_tree().quit(0)
