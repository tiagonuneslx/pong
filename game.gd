extends Node

var score1 := 0
var score2 := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Player2.isAi:
		$Player2.isAiPressingUp = false
		$Player2.isAiPressingDown = false
		var ballDistance = $Ball.position.y - $Player2.position.y
		if abs(ballDistance) > 20:
			if ballDistance > 0:
				$Player2.isAiPressingDown = true
			else:
				$Player2.isAiPressingUp = true

func start_game():
	score1 = 0
	score2 = 0
	update_score()
	$Winner.hide()
	$Player1.start()
	$Player2.start()
	$Player2.isAi = true
	$Ball.start()
	$Music.play()

func update_score():
	$Score1.text = str(score1)
	$Score2.text = str(score2)


func _on_ball_score(playerId: Player.PlayerId) -> void:
	if playerId == Player.PlayerId.Player1:
		score1 += 1
	else:
		score2 += 1
	update_score()
	$ScoreSound.play()
	
	if score1 == 5 || score2 == 5:
		if score1 == 5:
			$Winner.text = "[color=#5fcde4]Blue[/color] wins!"
		if score2 == 5:
			$Winner.text = "[color=#d95763]Red[/color] wins!"
		
		$Winner.show()
		await get_tree().create_timer(2.0).timeout
		$Ball.hide()
		$StartButton.show()
		
	else:
		$Ball.start()


func on_start_button_pressed() -> void:
	start_game()
	$StartButton.hide()


func _on_ball_bounce() -> void:
	$BounceSound.play()
