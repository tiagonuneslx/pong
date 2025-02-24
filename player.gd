extends CharacterBody2D
class_name Player

enum PlayerId {Player1, Player2}

@export var playerId: PlayerId

static var controls = {
	PlayerId.Player1: {
		"up": "move_up_p1",
		"down": "move_down_p1",
	},
	PlayerId.Player2: {
		"up": "move_up_p2",
		"down": "move_down_p2",
	}
}

var color = {
	PlayerId.Player1: Color(95 / 255.0, 205 / 255.0, 228 / 255.0),
	PlayerId.Player2: Color(217 / 255.0, 87 / 255.0, 99 / 255.0),
}

@export var speed := 200
@export var aiSpeed := 160
var screen_size

@export var isAi = false
@export var isAiPressingUp = false
@export var isAiPressingDown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	modulate = color[playerId]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.y = 0
	
	if isAi:
		if isAiPressingUp:
			velocity.y = -aiSpeed
		if isAiPressingDown:
			velocity.y = aiSpeed
	
	if Input.is_action_pressed(controls[playerId]["up"]):
		velocity.y = -speed
		isAi = false
	if Input.is_action_pressed(controls[playerId]["down"]):
		velocity.y = speed
		isAi = false

	move_and_collide(velocity * delta)

func start():
	position.y = screen_size.y / 2
