extends KinematicBody2D

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
#getting access to the root in animaiton tree#
onready var animation_state = animation_tree.get("parameters/playback")

var velocity = Vector2.ZERO

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	#walking sideways is faster, so normalized() sets up the vector to a circle instead of raduis 1#
	input_vector = input_vector.normalized() 
	
	if input_vector != Vector2.ZERO:
		#sets blend postion for idle and run#
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		
		animation_state.travel("Run")
		
		#value to move towards * the amount to move towards that#
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animation_state.travel("Idle")
		#move_toward applies friction to the movement#
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	#move_and_slide habdles delta#
	velocity = move_and_slide(velocity)
