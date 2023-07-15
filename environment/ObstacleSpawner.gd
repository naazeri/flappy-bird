extends Node2D

signal onObstacleSpawned(obstacle)

onready var timer = $Timer

const waitTime := 1.5  # second

var Obstacle = preload("res://environment/Obstacle.tscn")


func _ready():
	randomize()

	# set timer
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.wait_time = waitTime


func _on_Timer_timeout():
	spawnObstacle()


func start():
	timer.start()


func stop():
	timer.stop()


func spawnObstacle():
	var obstacle = Obstacle.instance()
	add_child(obstacle)
	obstacle.position.y = rand_range(150, 550)

	emit_signal("onObstacleSpawned", obstacle)
