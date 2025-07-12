extends Control

@onready var sprrite = $Sprite2D
@onready var Scena1 = $Scena1
@onready var player = get_node("/root/game/Player")
@onready var HeartSprite := get_node("/root/game/UI_Layer/MinigameContainer/BreathingMinigame/AnimatedSprite2D")
@onready var VisualNode = get_node("/root/game/UI_Layer/MinigameContainer/BreathingMinigame/Scena1")
func start():
	# Disabilita movimento e interazione player
	player.can_move = false
	player.can_interact = false
	VisualNode.reset_minigame()
	Scena1.Show_Square()
	Scena1.input_enabled = true
	HeartSprite.visible = true
	self.visible = true
	
func stop():
	# Riabilita movimento e interazione player
	player.can_move = true
	player.can_interact = true

	self.visible = false
	Scena1.input_enabled = false
	HeartSprite.visible = false
