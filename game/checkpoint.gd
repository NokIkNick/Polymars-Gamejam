extends Area2D
@onready var checkpoint = $"."
@onready var sprite_2d = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture = load("res://sprites/checkpoint_unlit.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(body.name == "Player"):
		sprite_2d.texture = load("res://sprites/checkpoint_lit.png")
		body.set_checkpoint(checkpoint)
