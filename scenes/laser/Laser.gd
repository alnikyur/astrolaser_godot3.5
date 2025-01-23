extends RigidBody2D

export var speed: float = 500 
export var direction: Vector2 = Vector2(0, -1)
#onready var explosion = $Explosion

#signal asteroid_destroyed(amount: int)

func _ready():
	set_deferred("freeze", true)
	add_to_group("lasers")
	
	gravity_scale = 0
	linear_velocity = direction * speed
	
func _process(delta):
	position += direction * speed * delta
	
	if position.y < -50 or position.y > 530 or position.x < -50 or position.x > 690:
		queue_free()


func _exit_tree():
	remove_from_group("lasers")
