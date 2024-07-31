extends Node

@onready var timer_label = $CanvasLayer/Timer
@onready var start_position = $StartPosition
@onready var player = $Player

func _ready():
	player.position = start_position.position
	player.set_checkpoint(start_position)


