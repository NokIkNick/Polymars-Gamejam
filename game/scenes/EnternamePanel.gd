extends Panel

@onready var leaderboard_fetcher = $"../LeaderboardFetcher"
@onready var text_edit = $TextEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_edit_text_changed():
	leaderboard_fetcher._change_player_name(text_edit.text)
