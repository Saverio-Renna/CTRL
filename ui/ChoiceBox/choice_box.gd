extends Control

@onready var player = get_node("/root/game/Player")
@onready var TextBox = get_node("/root/game/TextBox")
@onready var AnxietyIndicator = get_node("/root/game/UI_Layer/AnxietyIndicator")

var current_effects = []
var current_object = null

func _ready() -> void:
	var button1 := get_node("Panel/VBoxContainer/Button 1")
	var button2 := get_node("Panel/VBoxContainer/Button 2")
	var button3 := get_node("Panel/VBoxContainer/Button 3")

	button1.pressed.connect(_on_button_1_pressed)
	button2.pressed.connect(_on_button_2_pressed)
	button3.pressed.connect(_on_button_3_pressed)

func _on_button_pressed(value):
	AnxietyIndicator.change_anxiety(value)
	player.can_interact = true
	TextBox.hide_TextBox()
	self.visible = false

func _on_button_1_pressed():
	_on_button_pressed(current_effects[0])

func _on_button_2_pressed():
	_on_button_pressed(current_effects[1])

func _on_button_3_pressed():
	_on_button_pressed(current_effects[2])

func show_Choice(array):
	self.position = player.global_position + Vector2(0, 40)
	self.visible = true
	current_effects = [array[0]["effect"], array[1]["effect"], array[2]["effect"]]

	var button1 := get_node("Panel/VBoxContainer/Button 1")
	var button2 := get_node("Panel/VBoxContainer/Button 2")
	var button3 := get_node("Panel/VBoxContainer/Button 3")

	button1.text = array[0]["choice"]
	button2.text = array[1]["choice"]
	button3.text = array[2]["choice"]

func has_Choice(obj): 
	if obj == null:
		print("Oggetto nullo")
		return

	current_object = obj
	
	if obj.has_method("get_has_choices") and obj.get_has_choices():
		var choices = obj.get_choices()
		var anxiety_up = obj.get_anxiety_up()
		var anxiety_down = obj.get_anxiety_down()
		var effects = [anxiety_up, anxiety_down, 0]
		var array = random_pos(choices, effects)
		show_Choice(array)

func random_pos(choices, effects):
	var accoppiati = []
	for i in range(choices.size()):
		accoppiati.append({
			"choice": choices[i],
			"effect": effects[i]
		})
	accoppiati.shuffle()
	return accoppiati
