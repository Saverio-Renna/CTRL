extends Control

@onready var bar = $TextureProgressBar
@onready var label = $Label  # opzionale
@onready var anxiety_effects = get_node("/root/game/UI_Layer/AnxietyEffects")
@onready var AnxietyIndicator = get_node("/root/game/UI_Layer/AnxietyIndicator")
var anxiety := 0
var max_anxiety := 100

func _ready():
	anxiety = 40
	update_display()

func change_anxiety(value: int):
	anxiety = clamp(anxiety + value, 0, max_anxiety)
	
	anxiety_effect(anxiety)
	update_display()

func update_display():
	bar.value = anxiety
	label.text = "Ansia: " + str(anxiety) + "%"

func anxiety_effect(anxiety):
	if anxiety >= 0 and anxiety <= 59:
		print("0-59")
		
		reset()
		anxiety_effects.play_memories_of_winter(-30)

	elif anxiety >= 60 and anxiety <= 69:
		print("60-70")
		
		reset()
		anxiety_effects.set_saturation(0.8)
		
	elif anxiety >= 70 and anxiety <= 79:
		print("70-80")
		
		reset()
		anxiety_effects.set_saturation(0.6)
		anxiety_effects.set_vignette_strength(0.2)
		anxiety_effects.play_heartbeat(0.5)
		
	elif anxiety >= 80 and anxiety <= 89:
		print("80-90")
		
		reset()
		anxiety_effects.set_saturation(0.4)
		anxiety_effects.set_vignette_strength(0.4)
		anxiety_effects.play_heartbeat(1)
		
	elif anxiety >= 90 and anxiety <= 99:
		print("90-99")
		
		reset()
		anxiety_effects.set_saturation(0.2)
		anxiety_effects.set_vignette_strength(0.8)
		anxiety_effects.play_heartbeat(1.5)
		anxiety_effects.start_camera_shake(5)

	elif anxiety >= 100:
		print("ATTACCU DU PANICUU")
		
		reset()
		anxiety_effects.set_saturation(0.0)
		anxiety_effects.set_vignette_strength(1.0)
		anxiety_effects.play_heartbeat(2.0)
		anxiety_effects.start_camera_shake(10)
		
		var player = get_node("/root/game/Player")
		player.block_release = true  # blocca riattivazione movimento alla chiusura della TextBox

		MinigamesManager.get_minigame()
		
		
		
func reset():
	anxiety_effects.set_saturation(1.0)
	anxiety_effects.set_vignette_strength(0.0)
	anxiety_effects.stop_heartbeat()
	anxiety_effects.stop_camera_shake()
