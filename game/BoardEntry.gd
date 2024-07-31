extends HBoxContainer

var player_name = "Name"
var player_time = "Time"

@onready var namelabel = $Name
@onready var time = $Time


# Called when the node enters the scene tree for the first time.
func _ready():
	update_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_labels():
	namelabel.text = "%s" % player_name
	time.text = "%s" % player_time
