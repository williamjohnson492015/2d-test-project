extends CanvasLayer
signal start_game

@onready var main_menu = $MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_high_score(Global.save_data.high_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over(score):
	# Show gameover message
	show_message("Game Over")
	await $MessageTimer.timeout
	# Check for new high score
	if score > Global.save_data.high_score:
		set_high_score(score)
		show_message("New High Score!")
		await $MessageTimer.timeout
	# Reset to Start state
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$HighScoreLabel.show()
	main_menu.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	
func update_high_score(high_score):
	$HighScoreLabel.text = "High Score: " + str(high_score)
	
func set_high_score(high_score):
	Global.save_data.high_score = high_score
	Global.save_data.save()
	update_high_score(high_score)

func _on_start_button_pressed() -> void:
	main_menu.hide()
	$HighScoreLabel.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
