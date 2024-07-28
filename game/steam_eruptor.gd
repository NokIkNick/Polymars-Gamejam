extends Node

@onready var gpu_particles_2d = $GPUParticles2D
@onready var audio_stream_player = $AudioStreamPlayer


const speed := 1200.0;


func _process(delta):
	pass


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(body.name == "Player"):
		body.velocity.y = 0
		body.velocity.y -= speed
		gpu_particles_2d.emitting = true
		var cam = body.get_child(2)
		cam.add_trauma(0.5)
		body.add_speed(200)
		audio_stream_player.play()
	
