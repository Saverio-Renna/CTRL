extends CharacterBody2D

func _ready():
	connect("body_entered", Callable(get_parent(), "_on_Ball_body_entered"))
