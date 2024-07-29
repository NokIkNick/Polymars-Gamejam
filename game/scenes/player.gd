extends CharacterBody2D


var speed = 300.0
const ORIGINAL_SPEED = 300.0
const MAX_SPEED = 1600.0
const JUMP_VELOCITY = -900.0
var last_checkpoint = null
var timer_started = false
var too_fast = false
@onready var sprite_2d = $Sprite2D
@onready var speed_label = $"../CanvasLayer/SpeedLabel"
@onready var coyote_timer = $CoyoteTimer
@onready var character_body_2d = $"."
@onready var audio_stream_player = $AudioStreamPlayer
@onready var ui = $"../UI"
@onready var speed_timer = $SpeedTimer


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func update_speedometer():
	speed_label.text = "Heat: %s"% abs(velocity.x)
	if(speed >= 1200 && speed < MAX_SPEED -50):
		speed_label.set_modulate(Color(255,255,0))
	elif(speed >= MAX_SPEED-50):
		speed_label.set_modulate(Color(255,0,0))
	else: 
		speed_label.set_modulate(Color(255,255,255))

func update_run_animations():
	if(velocity.x > 1  || velocity.x < -1):
		if(speed > ORIGINAL_SPEED *2 && speed < ORIGINAL_SPEED *3):
			sprite_2d.animation = "sprint"
		elif(speed > ORIGINAL_SPEED * 3):
			sprite_2d.animation = "fullsprint"
		else:
			sprite_2d.animation = "run"
	else:
		if(speed > ORIGINAL_SPEED && speed < 300):
			speed -=1 
		
		speed = 300
		sprite_2d.animation = "idle"

func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if(speed > ORIGINAL_SPEED *2 && speed < ORIGINAL_SPEED *3):
			sprite_2d.animation = "sprint_jump"
		else: if(speed > ORIGINAL_SPEED * 3):
			sprite_2d.animation = "fullsprint_jump"
		else:
			sprite_2d.animation = "jump_single"

func update_sprite_by_speed():
	if(speed > ORIGINAL_SPEED * 2):
		sprite_2d.speed_scale = 2.0
	else: if(speed > ORIGINAL_SPEED * 3):
		sprite_2d.speed_scale = 3.0
	else: if(speed > ORIGINAL_SPEED * 4):
		sprite_2d.speed_scale = 4.0
	else:
		sprite_2d.speed_scale = 1.0

func jump_cut():
	if(velocity.y < -100):
		velocity.y = -100

func handle_jump():
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY
		audio_stream_player.play()
	
	if(Input.is_action_just_released("jump")):
		jump_cut()


func handle_movement():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		if(speed < MAX_SPEED):
			speed +=1
		
		if(speed < 300):
			speed = 300
	else:
		velocity.x = move_toward(velocity.x, 0, 45)
		speed -= 10

func add_speed(amount) -> void:
	if((speed + amount) > MAX_SPEED):
		pass
	
	if(speed < MAX_SPEED):
		speed += amount

func _ready():
	last_checkpoint = null

func reset():
	if(last_checkpoint != null):
		position = last_checkpoint.position
		velocity.x = 0
		velocity.y = 0

func set_checkpoint(checkpoint) -> void:
	last_checkpoint = checkpoint

func handle_speed_timer():
		
		if(speed_timer.is_stopped() && too_fast && timer_started):
			timer_started = false
			too_fast = false
			print("Timer has stopped!")
			reset()
			
	
		if(speed >= MAX_SPEED -50):
			if(speed_timer.is_stopped() && !too_fast && !timer_started):
				print("too fast! Starting timer!")
				timer_started = true
				too_fast = true
				speed_timer.start()
		else: if(speed < MAX_SPEED -50):
			print("Not going too fast any longer")
			timer_started = false
			too_fast = false
			speed_timer.stop()

func remove_speed(amount) -> void:
	if(speed > 0):
		speed -= amount

#update function
func _physics_process(delta):
	
	# Speedometer:
	update_speedometer()
	
	# Animations:
	update_run_animations()
	
	# Gravity:
	add_gravity(delta)
	
	# Changing sprite & animationspeed according to speed:
	update_sprite_by_speed()

	# Handle jump.
	handle_jump()

	# Movement input
	handle_movement()
	

	#Manual Reset
	if(Input.is_action_just_pressed("reset")):
		reset()

	handle_speed_timer()
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	
	##Coyote timer:
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft


