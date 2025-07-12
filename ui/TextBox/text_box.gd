extends Control

@onready var label = $NinePatchRect/MarginContainer/Label
@onready var rect = $NinePatchRect
@onready var choice_box = get_node("/root/game/ChoiceBox")
@onready var player = get_node("/root/game/Player")

const MAX_WIDTH = 300

var pages: Array = []
var current_page: int = 0
var current_object = null

func _ready():
	visible = false
	pages = [""]
	current_page = 0
	show_current_page(Vector2.ZERO, false)

func show_TextBox(pages_array: Array, pos_mondo: Vector2, object):
	pages = pages_array
	current_page = 0 
	player.can_move = false
	current_object = object  # <-- salva riferimento all’oggetto
	show_current_page(pos_mondo, true)

func show_current_page(pos_mondo: Vector2, show):
	label.text = pages[current_page]
	label.custom_minimum_size.x = MAX_WIDTH
	await get_tree().process_frame
	await get_tree().process_frame

	rect.custom_minimum_size = label.get_combined_minimum_size() + Vector2(40, 40)
	await get_tree().process_frame

	self.position = pos_mondo - Vector2(0, 5)
	if show:
		fade_in()

func next_page():
	if current_page + 1 >= pages.size():
		fade_out().connect("finished", Callable(self, "_on_fade_out_finished_hide"))
	elif current_page == pages.size() - 2:
		player.can_interact = false
		fade_out().connect("finished", Callable(self, "_on_fade_out_finished_next"))
		choice_box.has_Choice(current_object)  # <-- passa oggetto corretto
	else:
		fade_out().connect("finished", Callable(self, "_on_fade_out_finished_next"))

func hide_TextBox():
	self.visible = false
	pages = []
	current_page = 0

	if not player.block_release:
		player.can_move = true
	else:
		player.block_release = false

func fade_in(duration := 0.3) -> void:
	self.modulate.a = 0.0
	self.visible = true
	create_tween().tween_property(self, "modulate:a", 1.0, duration)

func _on_fade_out_finished_next():
	current_page += 1
	show_current_page(self.position, true)

func _on_fade_out_finished_hide():
	hide_TextBox()

func fade_out(duration := 0.3):
	return create_tween().tween_property(self, "modulate:a", 0.0, duration)
