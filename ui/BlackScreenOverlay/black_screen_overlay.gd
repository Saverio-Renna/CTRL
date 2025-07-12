extends CanvasLayer

@onready var ColorRectNode: Control = $Overlay
@onready var LabelNode: Label = $OverlayLabel
@onready var player: Node = get_node("/root/game/Player")

var can_dismiss := false

func _ready():
	# Verifica che i nodi siano validi
	if ColorRectNode == null or LabelNode == null:
		push_error(" BlackScreenOverlay: Nodo mancante. Controlla i path")
		return

	# Impedisce il passaggio del click ai nodi sottostanti
	ColorRectNode.mouse_filter = Control.MOUSE_FILTER_STOP

	set_process_input(true)
	visible = false

func show_message(text: String):
	if player == null:
		push_error("Player non trovato. Controlla il path.")
		return

	LabelNode.text = text
	visible = true
	can_dismiss = true

	# Posiziona Overlay al centro del player (aggiusta a piacere)
	

	# Disabilita movimento/interazione
	player.can_move = false
	player.can_interact = false

func hide_overlay():
	can_dismiss = false
	visible = false

	if player:
		player.can_move = true
		player.can_interact = true

	queue_free()

func _input(event):
	if can_dismiss and event is InputEventMouseButton and event.pressed:
		hide_overlay()
