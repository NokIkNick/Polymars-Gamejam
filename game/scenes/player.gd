extends CharacterBody2D


var speed = 300.0
const ORIGINAL_SPEED = 300.0
const MAX_SPEED = 1600.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D
@onready var speed_label = $"../CanvasLayer/SpeedLabel"
@onready var coyote_timer = $CoyoteTimer
@onready var character_body_2d = $"."


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func update_speedometer():
	speed_label.text = "Speed: %s"% velocity.x
	if(speed >= 1200):
		speed_label.set("theme_override_colors/font_color", Color(1.0,0.0,0.0,1.0))
	else:
		speed_label.set("theme_override_colors/font_color", Color(255,255,255))

func update_run_animations():
	if(velocity.x > 1  || velocity.x < -1):
		if(speed > ORIGINAL_SPEED *2 && speed < ORIGINAL_SPEED *3):
			sprite_2d.animation = "sprint"
		else: if(speed > ORIGINAL_SPEED * 3):
			sprite_2d.animation = "fullsprint"
		else:
			sprite_2d.animation = "run"
	else:
		if(speed > ORIGINAL_SPEED):
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

func handle_jump():
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY

func handle_movement():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		if(speed < MAX_SPEED):
			speed +=1
	else:
		velocity.x = move_toward(velocity.x, 0, 12)
		speed -= 10

func _on_Area2D_area_entered(area):
	print("collision!")
	if(area.name == "SteamEruptor" && is_on_floor()):
		velocity.y = JUMP_VELOCITY * 2

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

	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	##Coyote timer:
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
	
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
