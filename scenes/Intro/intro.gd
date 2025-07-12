extends Control

func _ready():
	$AnimationPlayer.play("Intro")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://scenes/pre_scena1/pre_scena1.tscn")
