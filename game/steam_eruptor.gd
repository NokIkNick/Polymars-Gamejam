extends Node

@onready var cpu_particles_2d = $CPUParticles2D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var steam_eruptor = $"."


const speed := 1400.0;





func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(body.name == "Player"):
		body.velocity.y = 0
		var direction = -steam_eruptor.transform.y.normalized()
		body.velocity += direction * speed
		cpu_particles_2d.emitting = true
		var cam = body.get_child(2)
		cam.add_trauma(0.5)
		body.add_speed(200)
		audio_stream_player.play()
	
