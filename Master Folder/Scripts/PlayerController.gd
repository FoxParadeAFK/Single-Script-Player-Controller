extends CharacterBody2D

var Gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const MaxVelocity : float = 180
const Acceleration : float = 6
const Deceleration : float = 12
var AccelerationValue : float

var VelocityVector : Vector2
var MovementDirection : int
var FacingDirection : int

var anim : AnimationPlayer

func _init():
	floor_stop_on_slope = true
	floor_constant_speed = true
	floor_snap_length = 4	
	FacingDirection = 1
	
func _ready():
	anim = $AnimationPlayer
	
func _process(delta):
	Controls()
	Animations()
	CheckIfShouldFlip()
	
func _physics_process(delta):
	
	VelocityVector = velocity
	
	Running(delta)
	if !is_on_floor(): VelocityVector.y += Gravity * delta
	
	velocity = VelocityVector
	
	move_and_slide()
	
func Controls():
	if (Input.is_action_just_pressed("MOVE_RIGHT")):
		MovementDirection = 1
		
	if (Input.is_action_just_pressed("MOVE_LEFT")):
		MovementDirection = -1
	
	if (Input.is_action_just_released("MOVE_RIGHT") || Input.is_action_just_released("MOVE_LEFT")):
		if (Input.is_action_pressed("MOVE_LEFT")):
			MovementDirection = -1
		elif (Input.is_action_pressed("MOVE_RIGHT")):
			MovementDirection = 1
		
		else: MovementDirection = 0
		
	print(MovementDirection)

func Running(delta : float):
	var MaxHorizontalVelocity : float = MaxVelocity * MovementDirection
	
	if (is_on_floor()): 
		AccelerationValue = Acceleration if (abs(MaxHorizontalVelocity) > 0) else Deceleration
	
	var SpeedDifference : float = MaxHorizontalVelocity - VelocityVector.x
	var Movement : float = SpeedDifference * AccelerationValue
	
	
	VelocityVector.x += delta * Movement
	
func CheckIfShouldFlip():
	if (FacingDirection != MovementDirection && MovementDirection != 0):
		Flip()
	
func Flip():
	FacingDirection *= -1
	scale.y *= -1
	rotation_degrees = 0 if FacingDirection == 1 else 180
	
func Animations():
	if (is_on_floor() && MovementDirection != 0):
		anim.play("Running")
	elif (is_on_floor() && MovementDirection == 0):
		anim.play("Idle")
