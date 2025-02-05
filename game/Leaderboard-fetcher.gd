extends Node

# Use this game API key if you want to test it with a functioning leaderboard
# "987dbd0b9e5eb3749072acc47a210996eea9feb0"
var game_API_key = ""
var development_mode = true
var leaderboard_key = ""
var session_token = ""
var score = 0
@onready var label = $"../Panel/ScrollContainer/Label"

var currentLeaderboard

# HTTP Request node can only handle one call per node
var auth_http = HTTPRequest.new()
var leaderboard_http = HTTPRequest.new()
var submit_score_http = HTTPRequest.new()

var set_name_http = HTTPRequest.new()
var get_name_http = HTTPRequest.new()

func _ready():
	_authentication_request()

func _process(_delta):
	if(Input.is_action_just_pressed("ui_up")):
		score += 1
		print("CurrentScore:"+str(score))
	
	if(Input.is_action_just_pressed("ui_down")):
		score -= 1
		print("CurrentScore:"+str(score))
	
	# Upload score when pressing enter
	if(Input.is_action_just_pressed("ui_accept")):
		_get_player_name()
	
	# Get score when pressing spacebar
	


func _authentication_request():
	# Check if a player session exists
	var player_session_exists = false
	var player_identifier : String
	var file = FileAccess.open("user://LootLocker.data", FileAccess.READ)
	if file != null:
		player_identifier = file.get_as_text()
		print("player ID="+player_identifier)
		file.close()
 
	if player_identifier != null and player_identifier.length() > 1:
		print("player session exists, id="+player_identifier)
		player_session_exists = true
	if(player_identifier.length() > 1):
		player_session_exists = true
		
	## Convert data to json string:
	var data = { "game_key": game_API_key, "game_version": "0.0.0.1", "development_mode": true }
	
	# If a player session already exists, send with the player identifier
	if(player_session_exists == true):
		data = { "game_key": game_API_key, "player_identifier":player_identifier, "game_version": "0.0.0.1", "development_mode": true }
	
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	
	# Create a HTTPRequest node for authentication
	auth_http = HTTPRequest.new()
	add_child(auth_http)
	auth_http.request_completed.connect(_on_authentication_request_completed)
	# Send request
	auth_http.request("https://api.lootlocker.io/game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
	print(data)


func _on_authentication_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Save the player_identifier to file
	var file = FileAccess.open("user://LootLocker.data", FileAccess.WRITE)
	if(json.get("player_identifier")):
		file.store_string(json.get_data().player_identifier)
		
	file.close()
	
	if(json.get("session_token")):
		session_token = json.get_data().session_token
	# Save session_token to memory
	
	
	# Print server response
	print(json.get_data())
	
	# Clear node
	auth_http.queue_free()
	# Get leaderboards
	_get_leaderboards()


func _get_leaderboards():
	print("Getting leaderboards")
	var url = "https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/list?count=10"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	leaderboard_http = HTTPRequest.new()
	add_child(leaderboard_http)
	leaderboard_http.request_completed.connect(_on_leaderboard_request_completed)
	
	# Send request
	leaderboard_http.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_leaderboard_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	
	# Formatting as a leaderboard
	var leaderboardFormatted = ""
	if(json.get("items")):
		for n in json.get_data().items.size():
			leaderboardFormatted += str(json.get_data().items[n].rank)+str(". ")
			leaderboardFormatted += str(json.get_data().items[n].player.id)+str(" - ")
			leaderboardFormatted += str(json.get_data().items[n].score)+str("\n")
	# Print the formatted leaderboard to the console
	print(leaderboardFormatted)
	
	
	# Clear node
	leaderboard_http.queue_free()


func _upload_score(score: String):
	var data = { "score": score }
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	submit_score_http = HTTPRequest.new()
	add_child(submit_score_http)
	submit_score_http.request_completed.connect(_on_upload_score_request_completed)
	# Send request
	submit_score_http.request("https://api.lootlocker.io/game/leaderboards/"+leaderboard_key+"/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	# Print what we're sending, for debugging purposes:
	print(data)

func _change_player_name(in_name):
	print("Changing player name")
	
	# use this variable for setting the name of the player
	var player_name = in_name
	
	var data = { "name": str(player_name) }
	var url =  "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	set_name_http = HTTPRequest.new()
	add_child(set_name_http)
	set_name_http.request_completed.connect(_on_player_set_name_request_completed)
	# Send request
	set_name_http.request(url, headers, HTTPClient.METHOD_PATCH, JSON.stringify(data))
	
func _on_player_set_name_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	set_name_http.queue_free()

func _get_player_name():
	print("Getting player name")
	var url = "https://api.lootlocker.io/game/player/name"
	var headers = ["Content-Type: application/json", "x-session-token:"+session_token]
	
	# Create a request node for getting the highscore
	get_name_http = HTTPRequest.new()
	add_child(get_name_http)
	get_name_http.request_completed.connect(_on_player_get_name_request_completed)
	# Send request
	get_name_http.request(url, headers, HTTPClient.METHOD_GET, "")

func _on_player_get_name_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	# Print player name
	if(json.get_data().name):
		print(json.get_data().name)
	else:
		print("unnamed")


func _on_upload_score_request_completed(result, response_code, headers, body) :
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	
	# Print data
	print(json.get_data())
	
	# Clear node
	submit_score_http.queue_free()
