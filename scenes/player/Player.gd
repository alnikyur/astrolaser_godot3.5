extends KinematicBody2D

export var Fire: PackedScene

onready var shoot = $Shoot
onready var laser_empty = $LaserEmpty
onready var shoot_count = $"../Score"
onready var score = $"../Shoots"

export var acceleration = 20000.0
export var max_speed = 20000.0
export var friction = 600.0

export var max_health: int = 100  # Максимальное здоровье
export var health_bar_path: NodePath  # Путь к шкале здоровья
var current_health: int = max_health  # Текущее здоровье



var max_fire_count = 100
var current_fire_count = max_fire_count
var current_score_count = 0

func _ready():
	get_tree().connect("node_added", self, "_on_node_added")
	var health_bar = get_node_or_null(health_bar_path)
	if health_bar:
		health_bar.value = current_health

func _on_node_added(node):
	if node.is_in_group("asteroids"):
		node.connect("asteroid_destroyed", self, "add_shots_on_asteroid_destruction")
		node.connect("asteroid_count", self, "add_score_count")


func _process(delta):
	var input_direction = Vector2.ZERO

	# Keyboard input support
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		input_direction.x += 1

	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1

	input_direction = input_direction.normalized()

	# Apply acceleration and friction
	var velocity = input_direction * acceleration * delta
	velocity = velocity.clamped(max_speed)

	# Apply movement
	move_and_slide(velocity)
	if Input.is_action_just_pressed("ui_select"):
		fire()

func fire():
	if get_tree().get_nodes_in_group("lasers").size() == 0:  # Проверяем, есть ли лазеры на экране
		if current_fire_count > 0:
			var num_lasers = 1
			if current_score_count >= 50:
				num_lasers = 3
			elif current_score_count >= 20:
				num_lasers = 2

			current_fire_count -= num_lasers
			update_shots_label()

			print("Shots left: ", current_fire_count)

			if num_lasers == 1 or num_lasers == 3:
				var center_fire = Fire.instance()
				center_fire.position = position + Vector2(320, 370)
				center_fire.add_to_group("lasers")  # Добавляем лазер в группу
				get_parent().add_child(center_fire)
				print("Laser created at: ", center_fire.position)

			if num_lasers >= 2:
				var left_fire = Fire.instance()
				left_fire.position = position + Vector2(320, 400)
				left_fire.add_to_group("lasers")  # Добавляем лазер в группу
				get_parent().add_child(left_fire)

			if num_lasers >= 2:
				var right_fire = Fire.instance()
				right_fire.position = position + Vector2(320, 400)
				right_fire.add_to_group("lasers")  # Добавляем лазер в группу
				get_parent().add_child(right_fire)

			shoot.play()
		else:
			print("No shots left!")
			laser_empty.play()
	else:
		print("Cannot shoot: lasers still on screen!")



func update_shots_label():
	shoot_count.text = "Shots: %d" % current_fire_count

func update_score_label():
	score.text = "Score: %d" % current_score_count

func add_shots_on_asteroid_destruction(amount: int):
	current_fire_count = min(current_fire_count + amount, max_fire_count)
	update_shots_label()
	print("Shots added: %d, current shots: %d" % [amount, current_fire_count])

func add_score_count(amount: int):
	current_score_count += amount
	update_score_label()
	print("Score added: %d, current score: %d" % [amount, current_score_count])

func increase_health(amount: int):
	# Увеличиваем здоровье, но не превышаем max_health
	current_health = clamp(current_health + amount, 0, max_health)

	# Обновляем шкалу здоровья
	var health_bar = get_node_or_null(health_bar_path)
	if health_bar:
		health_bar.value = current_health
		print("Health bar updated to: ", current_health)

func _on_area_2d_body_entered(body):
	print("Entered body: ", body.name)
	if body.is_in_group("health"):  # Проверяем, принадлежит ли объект группе health_points
		body.queue_free()  # Удаляем health_point
		restore_health()

func restore_health():
	current_health = max_health  # Полностью восстанавливаем здоровье
	update_health_bar()
	var asteroid_catcher = get_parent().get_node("AsteroidCatcher")  # Укажите правильный путь
	if asteroid_catcher:
		asteroid_catcher.sync_health()


func update_health_bar():
	# Обновляем шкалу здоровья
	var health_bar = get_node_or_null(health_bar_path)
	if health_bar:
		health_bar.value = current_health
		print("Health bar updated to: ", current_health)
