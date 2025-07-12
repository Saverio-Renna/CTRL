extends Node

@onready var BreathingMinigame = get_node("/root/game/UI_Layer/MinigameContainer/BreathingMinigame")
@onready var HandTracingMinigame = get_node("/root/game/UI_Layer/MinigameContainer/HandTracingMinigame")
@onready var player = get_node("/root/game/Player")

var count = 0

func get_minigame():
	count += 1
	player = get_node("/root/game/Player")
	player.can_move = false
	player.can_interact = false
	BreathingMinigame = get_node("/root/game/UI_Layer/MinigameContainer/BreathingMinigame")
	BreathingMinigame.start()
	
	
func get_count():
	return count
	#if count == 1:
	#BreathingMinigame.start()
	#elif count == 2:
		#HandTracingMinigame.start_game()
	#else:
		#count = 0
	
	#player.can_move = true
