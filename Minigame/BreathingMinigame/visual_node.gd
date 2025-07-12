extends Node2D

@onready var circle = $Circle
@onready var square = $Square
@onready var player = get_node("/root/game/Player")
@onready var PhaseLabel = get_node("/root/game/UI_Layer/MinigameContainer/BreathingMinigame/PhaseLabel")
@onready var SubLabel = get_node("/root/game/UI_Layer/MinigameContainer/BreathingMinigame/SubLabel")
@onready var BreathingMinigame = get_node("/root/game/UI_Layer/MinigameContainer/BreathingMinigame")
@onready var AnxietyIndicator = get_node("/root/game/UI_Layer/AnxietyIndicator")
@onready var HeartSprite := get_node("/root/game/UI_Layer/MinigameContainer/BreathingMinigame/AnimatedSprite2D")

var input_enabled := false
var can_animate := false
var started := false
var waiting_for_restart := false
var pending_black_screen := false

var points = []
var current_index = 0

var current_phase := ""
var has_made_mistake := false
var is_in_tolerance := true

var count = 0
var life := 3

var tolerance_timer := Timer.new()

func _ready():
	var viewport_center = get_viewport_rect().size / 2
	square.position = viewport_center
	var square_size = square.texture.get_size()
	var half_w = (square_size.x + 58) / 2
	var half_h = (square_size.y + 58) / 2

	PhaseLabel.position = viewport_center
	PhaseLabel.position.y -= half_h * 2 - 30
	SubLabel.position = PhaseLabel.position - Vector2(0, -20)

	var top_left = square.position + Vector2(-half_w, -half_h)
	var top_right = square.position + Vector2(half_w, -half_h)
	var bottom_right = square.position + Vector2(half_w, half_h)
	var bottom_left = square.position + Vector2(-half_w, half_h)

	points = [bottom_left, top_left, top_right, bottom_right]
	circle.position = points[0]

	tolerance_timer.one_shot = true
	tolerance_timer.wait_time = 0.5
	tolerance_timer.timeout.connect(_on_tolerance_timer_timeout)
	add_child(tolerance_timer)


func Show_Square():
	
	self.visible = true
	can_animate = true
	started = false
	waiting_for_restart = false
	pending_black_screen = false
	input_enabled = true

	life = 3
	count = 0
	update_lives_ui(life)

	PhaseLabel.text = "CLICCA PER INIZIARE"
	SubLabel.text = "(Tasto sinistro)"

func _on_tolerance_timer_timeout():
	is_in_tolerance = false

func _process(_delta):
	if waiting_for_restart:
		if not input_enabled:
			return
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			if pending_black_screen:
				show_black_screen()
				pending_black_screen = false
			else:
				self.visible = false
				BreathingMinigame.stop()
			return

	if not can_animate or has_made_mistake:
		return

	var left_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	var right_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)

	if not started:
		if left_pressed:
			started = true
			move_to_next_point()
		return

	if is_in_tolerance:
		return

	match current_phase:
		"inspira":
			if not left_pressed or right_pressed:
				has_mistake()
		"espira":
			if not right_pressed or left_pressed:
				has_mistake()
		"trattieni1", "trattieni2":
			if left_pressed or right_pressed:
				has_mistake()

func move_to_next_point():
	if not can_animate:
		return

	current_index = (current_index + 1) % points.size()
	var tween = create_tween()
	tween.tween_property(circle, "position", points[current_index], 4.0)

	has_made_mistake = false
	is_in_tolerance = true
	tolerance_timer.start()

	match current_index:
		1:
			current_phase = "inspira"
			PhaseLabel.text = "INSPIRA"
			SubLabel.text = "(Click Sinistro)"
		2:
			current_phase = "trattieni1"
			PhaseLabel.text = "TRATTIENI"
			SubLabel.text = "(Nessun Click)"
		3:
			current_phase = "espira"
			PhaseLabel.text = "ESPIRA"
			SubLabel.text = "(Click Destro)"
		0:
			current_phase = "trattieni2"
			PhaseLabel.text = "TRATTIENI"
			SubLabel.text = "(Nessun Click)"
			count += 1

	if count >= 2:
		print("✅ Hai completato il minigioco!")
		can_animate = false
		PhaseLabel.text = "SEI RIUSCITO A CALMARTI"
		SubLabel.text = "Clicca per continuare"
		waiting_for_restart = true
		input_enabled = false
		delay_mouse_input(200, func(): input_enabled = true)
		AnxietyIndicator.change_anxiety(-70)
	else:
		tween.tween_callback(Callable(self, "move_to_next_point"))

func has_mistake():
	life -= 1
	has_made_mistake = true
	print("❌ Errore! Vite rimaste:", life)
	update_lives_ui(life)

	if life <= 0:
		print("💀 Game Over")
		can_animate = false
		PhaseLabel.text = "NON SEI RIUSCITO A CALMARTI"
		SubLabel.text = "Clicca per continuare"
		waiting_for_restart = true
		input_enabled = false
		delay_mouse_input(200, func(): input_enabled = true)
		pending_black_screen = true
		AnxietyIndicator.change_anxiety(-30)

func update_lives_ui(life: int):
	var frame = clamp(3 - life, 0, 3)
	HeartSprite.play("default")
	HeartSprite.frame = frame

func delay_mouse_input(duration_ms := 200, on_done: Callable = func() -> void: return):
	var timer := Timer.new()
	timer.wait_time = float(duration_ms) / 1000.0
	timer.one_shot = true
	add_child(timer)

	timer.timeout.connect(func():
		on_done.call()
		timer.queue_free()
	)
	timer.start()

func show_black_screen():
	var black_screen = preload("res://ui/BlackScreenOverlay/BlackScreenOverlay.tscn").instantiate()
	get_tree().root.add_child(black_screen)
	black_screen.show_message("Il protagonista resta a letto, tremando.\nIl respiro si blocca in gola. La stanza gira. Il rumore esterno diventa minaccioso,\nogni suono è amplificato. Dopo diversi minuti, lentamente,\nil battito torna normale. Il mondo sembra sfocato, ma il giorno continua.\n\n\nPREMI UN TASTO PER CONTINUARE")

func reset_minigame():
	input_enabled = false
	can_animate = false
	started = false
	waiting_for_restart = false
	pending_black_screen = false

	points = []
	current_index = 0

	current_phase = ""
	has_made_mistake = false
	is_in_tolerance = true

	count = 0
	life = 3

	tolerance_timer = Timer.new()
	
	
	var viewport_center = get_viewport_rect().size / 2
	square.position = viewport_center
	var square_size = square.texture.get_size()
	var half_w = (square_size.x + 58) / 2
	var half_h = (square_size.y + 58) / 2



	var top_left = square.position + Vector2(-half_w, -half_h)
	var top_right = square.position + Vector2(half_w, -half_h)
	var bottom_right = square.position + Vector2(half_w, half_h)
	var bottom_left = square.position + Vector2(-half_w, half_h)

	points = [bottom_left, top_left, top_right, bottom_right]
	circle.position = points[0]

	tolerance_timer.one_shot = true
	tolerance_timer.wait_time = 0.5
	tolerance_timer.timeout.connect(_on_tolerance_timer_timeout)
	add_child(tolerance_timer)

	
