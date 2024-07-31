extends Control

@export var board_entry_scene = (PackedScene)
@onready var leaderboard_fetcher = $LeaderboardFetcher
@onready var player_list = $Panel/ScrollContainer/PlayerList



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
