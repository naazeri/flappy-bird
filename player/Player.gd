extends RigidBody2D
class_name Player

signal died

onready var animator := $AnimationPlayer
onready var wingAudioPlayer = $WingAudioPlayer

const maxUpRotationDegrees := -30.0
const maxDownRotationDegrees := 90.0
const flapForce := -450
const rotateUpSpeed := -3
const rotateDownSpeed := 3
const gravity := 12.4
var started := false
var alive := true


func _ready():
	pass  # Replace with function body.


func _physics_process(_delta):
	if alive and Input.is_action_just_pressed("flap"):
		if not started:
			start()
		flap()
	handleRotate()


func start():
	started = true
	gravity_scale = gravity
	animator.play("Flap")


func flap():
	linear_velocity.y = flapForce
	angular_velocity = rotateUpSpeed
	wingAudioPlayer.play()


func die():
	if not alive:
		return

	alive = false
	animator.stop()
	emit_signal("died")
	print("died")


func handleRotate():
	if rotation_degrees <= maxUpRotationDegrees:
		angular_velocity = 0
		rotation_degrees = maxUpRotationDegrees

	if linear_velocity.y > 500:
		if rotation_degrees <= maxDownRotationDegrees:
			angular_velocity = rotateDownSpeed
		else:
			angular_velocity = 0
