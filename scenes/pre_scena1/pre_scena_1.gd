extends Control

func _ready():
	$AnimationPlayer.play("pre_scena1")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://game.tscn")
