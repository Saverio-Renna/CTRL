extends Area2D

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		var count = MinigamesManager.get_count()
		print("Minigame count:", count)

		if count <= 1:
			print("1")
			get_tree().change_scene_to_file("res://scenes/BadEnding/BadEnding.tscn")
		elif count >=3:
			print("3")
			get_tree().change_scene_to_file("res://scenes/goodEnding/goodEnding.tscn")
		elif count == 2:
			print("2")
			get_tree().change_scene_to_file("res://scenes/AlternativeEnding/AlternativeEnding.tscn")
