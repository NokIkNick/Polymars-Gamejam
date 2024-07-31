extends RigidBody2D

# Declare variables
var falling = false
var fall_speed = 300  # Adjust the falling speed as needed
var grav = 1000     # Gravity strength to apply to the object

func _ready():
	# Initialize the object, set to not falling initially
	falling = false

func start_falling():
	falling = true
	set_physics_process(true)  # Enable the physics process to handle the falling

func _physics_process(delta):
	if falling:
		# Apply gravity to the object
		position.y += fall_speed * delta
		fall_speed += grav * delta  # Increase falling speed to simulate gravity effect


