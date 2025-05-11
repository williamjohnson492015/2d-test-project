extends Node

@export var mob_scene: PackedScene
@onready var pause_menu = $PauseMenu
var score
var paused = false
var hidden_message = false
var state = 0 # 0 = not running, 1 = running

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") && state == 1: 
		pause()

func pause():
	if paused:
		pause_menu.hide()
		get_tree().paused = false
		if $HUD/Message.visible == false && hidden_message == true:
			hidden_message = false
			$HUD/Message.visible = true
	else:
		if $HUD/Message.visible == true: 
			hidden_message = true
			$HUD/Message.visible = false
		pause_menu.show()
		get_tree().paused = true
		
	paused = !paused

func game_over():
	# Update state
	state = 0
	# Stop timers
	$ScoreTimer.stop()
	$MobTimer.stop()
	# Stop Music
	$MainTheme.stop()
	# Play gameover sound
	$GameOverSound.play()
	# Clear all mobs
	get_tree().call_group("mobs", "queue_free")
	#Show game over message
	$HUD.show_game_over()
	

func new_game():
	# Set up new game
	state = 1
	$MainTheme.play()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
