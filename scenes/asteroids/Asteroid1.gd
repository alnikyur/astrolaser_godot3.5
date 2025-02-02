extends RigidBody2D

export var screen_width: int = 640
export var screen_height: int = 480
export var min_speed: float = 50.0
export var max_speed: float = 150.0
export var min_angle: float = PI / 4
export var max_angle: float = 3 * PI / 4
export var min_rotation_speed: float = 5
export var max_rotation_speed: float = 20

onready var explosion_particles = $Particles
onready var explosion = $AudioExplosion

signal asteroid_destroyed(amount)
signal asteroid_count(amount)

func _ready():
	add_to_group("asteroids")
	randomize()

	var angle = rand_range(min_angle, max_angle)
	var speed = rand_range(min_speed, max_speed)

	linear_velocity = Vector2(speed, 0).rotated(angle)
	angular_velocity = rand_range(min_rotation_speed, max_rotation_speed)


func _process(delta):
	if position.x < -50 or position.x > screen_width + 50 or position.y < -50 or position.y > screen_height + 50:
		queue_free()

func _physics_process(delta):
	pass


func _on_Asteroid1_body_entered(body):
	if body.is_in_group("lasers"):
		emit_signal("asteroid_destroyed", 3)
		emit_signal("asteroid_count", 1)
		print("Signal 'asteroid_count' emitted.")
		set_deferred("freeze", true)
		$AsteroidGray.visible = false
		explosion_particles.global_position = body.global_position
		explosion_particles.emitting = true
		explosion_particles.visible = true
		if is_instance_valid(body):
			body.queue_free()

		var temp_audio = AudioStreamPlayer.new()
		temp_audio.stream = explosion.stream
		temp_audio.volume_db = -10
		get_parent().add_child(temp_audio)
		temp_audio.play()
		temp_audio.connect("finished", temp_audio, "queue_free")

		yield(get_tree().create_timer(0.7), "timeout")
		if is_instance_valid(self):
			queue_free()
