extends CharacterBody2D

var nearby_object: Area2D = null
var can_interact = true
const SPEED = 300.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast = $RayCast2D

var can_move := true
var block_release = false  # <--- nuovo!

func _physics_process(delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		if animated_sprite:
			animated_sprite.play("idle_down")
		return

	var movement = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized()

	if movement != Vector2.ZERO and raycast:
		raycast.target_position = movement * 32
		raycast.force_raycast_update()

	update_animation(movement)
	velocity = movement * SPEED
	move_and_slide()

func update_animation(movement: Vector2) -> void:
	if not animated_sprite:
		#print("⚠️ animated_sprite è null!")
		return
	if movement != Vector2.ZERO:
		animated_sprite.play("walk_" + get_direction_as_string())
	else:
		animated_sprite.play("idle_" + get_direction_as_string())

func get_direction_as_string() -> String:
	if not raycast:
		print("⚠️ raycast è null!")
		return "down"
	var dir = raycast.target_position
	if dir.x > 0:
		return "right"
	elif dir.x < 0:
		return "left"
	elif dir.y > 0:
		return "down"
	elif dir.y < 0:
		return "up"
	return "down"

func _process(_delta):
	if Input.is_action_just_pressed("interact") and nearby_object and can_interact:
		print("hai premuto E")
		var textbox := get_node("/root/game/TextBox")
		if textbox.visible:
			textbox.next_page()
		else:
			nearby_object.spawn_textBox()
