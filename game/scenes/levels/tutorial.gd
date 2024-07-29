extends Node

@onready var timer_label = $CanvasLayer/Timer
@onready var timer = $Timer
@onready var player = $Player
@onready var start_position = $StartPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = start_position.position
	player.set_checkpoint(start_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
