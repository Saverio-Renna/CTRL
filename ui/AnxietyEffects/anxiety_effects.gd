extends Node

@onready var shader_rect := $ColorRect_Saturation
@onready var heartbeat_audio := $HeartbeatAudio
@onready var memories_of_winter := $play_memories_of_winter
@onready var shake_timer := $ShakeTimer
@onready var anxiety_indicator = get_node("/root/game/UI_Layer/AnxietyEffects")
@onready var camera_node: Camera2D = get_node("/root/game/Player/Camera2D")

var shake_range := 5.0  # Valore di default, modificabile da fuori


func _ready():
	shader_rect.size = get_viewport().size
	shader_rect.visible = true
	shader_rect.material.set_shader_parameter("saturation", 1.0)
	shader_rect.material.set_shader_parameter("vignette_strength", 0.0)
	heartbeat_audio.stop()
	shake_timer.stop()

# Effetto Saturazione (0.0 = bianco e nero, 1.0 = normale)
func set_saturation(amount: float):
	shader_rect.material.set_shader_parameter("saturation", clamp(amount, 0.0, 1.0))

#  Effetto Vignettatura (0.0 = assente, 1.0 = nero marcato)
func set_vignette_strength(amount: float):
	shader_rect.material.set_shader_parameter("vignette_strength", clamp(amount, 0.0, 1.0))

# Suono battito cardiaco (pitch 1.0 = normale, <1.0 = lento, >1.0 = veloce)
func play_heartbeat(pitch: float = 1.0):
	heartbeat_audio.pitch_scale = pitch
	if not heartbeat_audio.playing:
		heartbeat_audio.play()

func stop_heartbeat():
	heartbeat_audio.stop()
	
func play_memories_of_winter(valore):
	memories_of_winter.volume_db = valore
	if not memories_of_winter.playing:
		memories_of_winter.play()

func stop_memories_of_winter():
	memories_of_winter.stop()

# Camera shake
func start_camera_shake(range):
	shake_range = range
	if shake_timer.is_stopped():
		shake_timer.start()

func stop_camera_shake():
	shake_timer.stop()
	if camera_node:
		camera_node.offset = Vector2.ZERO



func shake_once():
	if camera_node:
		var offset = Vector2(randf_range(-shake_range, shake_range), randf_range(-shake_range, shake_range))
		camera_node.offset = offset
		await get_tree().create_timer(0.05).timeout
		camera_node.offset = Vector2.ZERO


func _on_shake_timer_timeout() -> void:
	if camera_node:
		var offset = Vector2(randf_range(-shake_range, shake_range), randf_range(-shake_range, shake_range))
		camera_node.offset = offset
		await get_tree().create_timer(0.05).timeout
		camera_node.offset = Vector2.ZERO
