extends Node2D

signal score

onready var topObstacle = $TopObstacle
onready var bottomObstacle = $BottomObstacle
onready var scoreArea = $ScoreArea

const speed := 215
const destroyPosition := -200
const restartPosition := 500


# Called when the node enters the scene tree for the first time.
func _ready():
	topObstacle.connect("body_entered", self, "on_Obstacle_body_entered")
	bottomObstacle.connect("body_entered", self, "on_Obstacle_body_entered")
	scoreArea.connect("body_exited", self, "on_ScoreArea_body_exited")


func _physics_process(delta):
	move(delta)


func move(delta):
	position.x += -speed * delta

	if global_position.x <= destroyPosition:
		# global_position.x = restartPosition
		queue_free()


func on_Obstacle_body_entered(body):
	if body is Player:
		var player: Player = body
		if player.has_method("die"):
			player.die()


func on_ScoreArea_body_exited(body):
	if body is Player:
		emit_signal("score")
