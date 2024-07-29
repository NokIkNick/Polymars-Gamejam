extends Area2D
@onready var timer = $"../CanvasLayer/Timer"
@onready var leaderboard_fetcher = $"../LeaderboardFetcher"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if(body.name == "Player"):
		timer.stop()
		leaderboard_fetcher.score = timer.score
		leaderboard_fetcher._change_player_name("Test")
		leaderboard_fetcher._get_player_name()
		leaderboard_fetcher._upload_score(leaderboard_fetcher.score)
		get_tree().change_scene_to_file("res://scenes/leaderboardScreen.tscn")
