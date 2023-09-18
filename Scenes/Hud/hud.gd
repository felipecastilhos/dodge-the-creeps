extends CanvasLayer

signal start_game

func show_message(text) -> void:
	var message: Label = $Message
	message.text = text
	message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message('Game Over')
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)


func _on_message_timer_timeout() -> void:
	$Message.hide()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()	
