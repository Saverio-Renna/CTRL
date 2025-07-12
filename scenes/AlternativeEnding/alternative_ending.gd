extends Control

func _ready():
	$AnimationPlayer.play("AlternativeEnding")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().quit()
