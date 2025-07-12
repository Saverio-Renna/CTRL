extends Area2D

@onready var choiceBox = get_node("/root/game/ChoiceBox")

var text = "[E] per interagire"
var textBox = [
	"Specchio, oggi cosa mi restituisci?"
]

var anxiety_up = 40
var anxiety_down = -10
var has_choices = true

var choices = [
	"Chi sto cercando di ingannare? (Ti fissi e ti critichi mentalmente)",
	"Forse non sembro così male… forse. (Ti guardi e cerchi di sorridere)",
	"È solo un volto. Uno qualunque.. (Ti osservi con distacco, senza emozioni)"
]

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body):
	if body.name == "Player":
		body.nearby_object = self
		var prompt := get_node("/root/game/InteractionUI")
		if prompt:
			var pos_mondo = self.global_position
			pos_mondo.y -= 35
			prompt.position = pos_mondo
			prompt.show_prompt(text, pos_mondo)

func _on_body_exited(body):
	if body.name == "Player":
		body.nearby_object = null
		var prompt := get_node("/root/game/InteractionUI")
		if prompt:
			prompt.hide_prompt()

func spawn_textBox():
	var prompt := get_node("/root/game/TextBox")
	if prompt:
		var player = get_node("/root/game/Player")
		var pos_mondo = player.global_position
		pos_mondo.y -= 35
		prompt.show_TextBox(textBox, pos_mondo, self)  # <--- PASSAGGIO OGGETTO

# Metodi usati da ChoiceBox
func get_has_choices():
	return has_choices

func get_choices():
	return choices

func get_anxiety_up():
	return anxiety_up

func get_anxiety_down():
	return anxiety_down
