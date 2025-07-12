extends Control

@onready var ball: CharacterBody2D = $Ball
@onready var life_indicator: AnimatedSprite2D = $LifeIndicator
@onready var timer: Timer = $Timer
@onready var collision_polygons: Array[CollisionPolygon2D] = [
	$HandCollisionArea/CollisionPolygon2D,
	$HandCollisionArea/CollisionPolygon2D2
]

var max_lives: int = 3
var current_lives: int = max_lives
var is_dragging: bool = false
var game_started: bool = false
var start_position: Vector2 = Vector2.ZERO
var end_position: Vector2 = Vector2(900, 300)  # Cambia con la posizione reale
var drag_offset: Vector2 = Vector2.ZERO
const PICK_RADIUS: float = 25.0

func _ready():
	self.visible = false
	timer.wait_time = 90
	timer.one_shot = true
	timer.timeout.connect(on_timer_timeout)
	start_position = ball.position
	update_life_indicator()

func start_game():
	game_started = true
	self.visible = true
	timer.start()
	ball.position = start_position
	ball.velocity = Vector2.ZERO
	is_dragging = false

func _process(_delta):
	if game_started and is_dragging:
		var target = get_global_mouse_position() - drag_offset
		var direction = (target - ball.global_position)
		if direction.length() > 1:
			ball.velocity = direction.normalized() * 300
		else:
			ball.velocity = Vector2.ZERO
	else:
		ball.velocity = Vector2.ZERO

	if game_started:
		for poly in collision_polygons:
			var polygon_points = poly.polygon
			var transform = poly.global_transform

			var transformed_poly = []
			for point in polygon_points:
				transformed_poly.append(transform.xform(point))

			if point_in_polygon(ball.global_position, transformed_poly):
				lose_life()
				break


func _physics_process(delta):
	ball.move_and_slide()

func _input(event):
	if not game_started:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var shape: Shape2D = ball.get_node("CollisionShape2D").shape
			if shape is CircleShape2D:
				var local_mouse := ball.to_local(get_global_mouse_position())
				if local_mouse.length() <= shape.radius + PICK_RADIUS:
					is_dragging = true
					drag_offset = get_global_mouse_position() - ball.global_position
		else:
			is_dragging = false

func point_in_polygon(point: Vector2, polygon: Array) -> bool:
	var inside := false
	var j := polygon.size() - 1
	for i in range(polygon.size()):
		var pi = polygon[i]
		var pj = polygon[j]
		if ((pi.y > point.y) != (pj.y > point.y)) and \
		   (point.x < (pj.x - pi.x) * (point.y - pi.y) / (pj.y - pi.y + 0.00001) + pi.x):
			inside = not inside
		j = i
	return inside

func lose_life():
	current_lives -= 1
	update_life_indicator()
	ball.position = start_position
	ball.velocity = Vector2.ZERO
	is_dragging = false
	print("❌ Hai perso una vita! Vite rimaste:", current_lives)
	if current_lives <= 0:
		game_over()

func update_life_indicator():
	life_indicator.frame = max_lives - current_lives

func game_over():
	game_started = false
	timer.stop()
	self.visible = false
	print("💀 Game Over")

func win_game():
	game_started = false
	timer.stop()
	self.visible = false
	print("✅ Hai completato il tracciamento!")

func on_timer_timeout():
	game_over()
