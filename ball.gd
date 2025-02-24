extends CharacterBody2D

signal score(playerId: Player.PlayerId)
signal bounce

@export var speed = 250
@export var speedIncrement = 20
var initial_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = Vector2(position)
	hide()

func start():
	position = Vector2(initial_position)
	velocity = Vector2.ZERO
	show()
	await get_tree().create_timer(1.0).timeout
	velocity = Vector2(speed, 0).rotated(randf_range(-PI / 4, PI / 4))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var other = collision.get_collider() as Node2D
		print("Ball is colliding with: " + other.name)
		if other.name == "Player1" || other.name == "Player2":
			var factor = (collision.get_position().y - other.global_position.y) / (other.get_node("Sprite2D") as Sprite2D).texture.get_height() + 0.5
			print("Factor: " + str(factor))
			velocity = Vector2(velocity.length(), 0).rotated(lerp(-PI / 4, PI / 4, factor))
			if(other.name == "Player2"):
				velocity.x = -velocity.x
			velocity += velocity.normalized() * speedIncrement
			print("New ball speed: " + str(velocity))
		else:
			velocity = velocity.bounce(collision.get_normal())
		bounce.emit()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	score.emit(Player.PlayerId.Player1 if position.x > 0 else Player.PlayerId.Player2)
