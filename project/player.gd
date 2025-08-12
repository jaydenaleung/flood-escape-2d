extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const LADDER_VELOCITY = 250.0
var player_climb := false

var room_completed := false

func _ready():
	var ladder = get_parent().get_node("ladder")
	ladder.connect("climb_changed", Callable(self, "_on_climb_changed"))	
	
func _on_climb_changed(value: bool) -> void:
	player_climb = value
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not player_climb:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor() and not player_climb:
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("ui_up") and player_climb: # Ladder logic
		velocity.y = -LADDER_VELOCITY
	elif Input.is_action_just_released("ui_up") and player_climb: # Ladder logic
		velocity.y = 0
	elif Input.is_action_just_pressed("ui_down") and player_climb: # Ladder logic
		velocity.y = LADDER_VELOCITY
	elif Input.is_action_just_released("ui_down") and player_climb: # Ladder logic
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
