extends RigidBody2D

export var screen_width: int = 640
export var screen_height: int = 480
export var min_speed: float = 150.0
export var max_speed: float = 250.0
export var min_angle: float = -PI
export var max_angle: float = PI
export var min_rotation_speed: float = 5
export var max_rotation_speed: float = 20
onready var explosion_particles = $explosion_particles
onready var explosion = $Explosion

#signal asteroid_destroyed(amount: int)
#signal asteroid_count(amount: int)

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


func _on_Asteroid0_body_entered(body):
	print("Collision detected with: ", body)
	if body.is_in_group("lasers"):
		print("Laser hit asteroid!")
		queue_free()
		body.queue_free()
	else:
		print("Body is not in group 'lasers'.")

#	if body.is_in_group("lasers"):
#		emit_signal("asteroid_destroyed", 3)
##		print("Signal 'asteroid_count' emitted.")
#		set_deferred("freeze", true)

#		explosion_particles.global_position = body.global_position
#		explosion_particles.emitting = true
#		explosion_particles.visible = true
#		if is_instance_valid(body):
#			body.queue_free()

#		var temp_audio = AudioStreamPlayer.new()
#		temp_audio.stream = explosion.stream
#		get_parent().add_child(temp_audio)
#		temp_audio.play()
#		temp_audio.connect("finished", temp_audio, "queue_free")

#		await get_tree().create_timer(0.7).timeout
#		if is_instance_valid(self):
#			queue_free()
