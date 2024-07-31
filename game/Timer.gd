extends Label

var time_elapsed := 0.0
var is_stopped := false
var score
@onready var timer_label = $"."


func _process(delta: float) -> void:
	if(!is_stopped):
		time_elapsed += delta
		timer_label.text = format_time(time_elapsed)
		score = format_time(time_elapsed)


func reset() -> void:
	time_elapsed = 0.0
	is_stopped = false


func stop() -> void:
	is_stopped = true
	

func format_time(in_seconds: float) -> String:
	# Calculate minutes, seconds, and milliseconds
	var minutes := int(in_seconds / 60)
	var remaining_seconds := int(int(in_seconds) % 60)
	var milliseconds := int((in_seconds - int(in_seconds)) * 1000)

	# Format the string with leading zeros
	return str(minutes).pad_zeros(2) + ":" + str(remaining_seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(3)
