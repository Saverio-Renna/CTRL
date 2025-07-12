extends Node2D

@onready var label = $Label  # riferimento al figlio

func show_prompt(text, pos_mondo):
	print("mostro la label")
	label.text = text
	self.visible = true

func hide_prompt():
	print("nascondo la label")
	self.visible = false
