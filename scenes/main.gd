extends Node2D

export var Asteroid: PackedScene
export var AsteroidGray: PackedScene
export var AsteroidBigGray: PackedScene
export var HealthPoint: PackedScene
export var spawn_interval: float = 1
export var screen_width: int = 640
export var screen_height: int = 480
export var asteroid_count: int = 1
export var asteroid_gray_count: int = 1
export var asteroid_big_gray_count: int = 1
export var health_point: int = 1
export var pause_menu_path: NodePath

onready var description = $Description
onready var fade_in_out = $FadeInOut

var is_paused = false
var score: int = 10

func _ready():
	randomize()
	$Timer.wait_time = spawn_interval
	$Timer.start()

#	fade_text_in()
#	yield(get_tree().create_timer(5.0), "timeout")
#	fade_text_out()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause_menu()

func toggle_pause_menu():
	var pause_menu = get_node(pause_menu_path)
	if pause_menu:
		is_paused = !is_paused
		get_tree().paused = is_paused
		pause_menu.visible = is_paused

func subtract_score(amount: int):
	score -= amount
	print("Score decreased! Current score: ", score)
	if score <= 0:
		game_over()

func game_over():
	print("Game Over!")

func _on_Timer_timeout():
	for i in range(asteroid_count):
		var asteroid = Asteroid.instance()
		add_child(asteroid)
		
		var x_position = rand_range(0, screen_width)
		var y_position = 0
		asteroid.position = Vector2(x_position, y_position)
#		print("Asteroid:", asteroid, "Position:", asteroid.position)
		
#	for i in range(asteroid_gray_count):
#		var asteroid_gray = AsteroidGray.instance()
#		add_child(asteroid_gray)
#		
#		var x_position = rand_range(-600, screen_width)
#		var y_position = -800
#		asteroid_gray.position = Vector2(x_position, y_position)

#	for i in range(asteroid_big_gray_count):
#		var asteroid_big_gray = AsteroidBigGray.instance()
#		add_child(asteroid_big_gray)
#		
#		var x_position = rand_range(-600, screen_width)
#		asteroid_big_gray.position = Vector2(x_position, y_position)

func _on_asteroid_catcher_body_entered(body):
	if body:
		print("ASTEROID DETECTED: ", body.name, " (Type: ", body.get_class(), ")")
		print("Groups: ", body.get_groups())

		if body.is_in_group("asteroids"):
			print("Asteroid caught and removed!")
			body.queue_free()
		else:
			print("Object is not an asteroid.")
	else:
		print("Collision detected, but no body found.")

func fade_text_in():
	fade_in_out.play("fadein")

func fade_text_out():
	fade_in_out.play("fadeout")


func _on_health_point_timer_timeout():
	for i in range(health_point):
		var health_point = HealthPoint.instantiate()
		add_child(health_point)
		
		var x_position = rand_range(-400, screen_width)
		var y_position = -800
		health_point.position = Vector2(x_position, y_position)



