extends Node

@export var mob_scene: PackedScene
@export var mobSpeedGrowth: float = 0.2
var score: float = 0.0
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Hud.show_game_over()
	score = 0
	$Music.stop()
	$DeathSound.play()
	
func new_game():
	$Hud.update_score(score)
	$Music.play()
	$Hud.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")

func _on_player_hit() -> void:
	game_over()

func _on_score_timer_timeout() -> void:
	score += 1
	$Hud.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout() -> void:
	spawn_mob()
	
func spawn_mob() -> void:
	var mob: Node2D = mob_scene.instantiate()
	
	var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction: float = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var minVelocity = 150.0  # Minimum velocity
	var maxVelocity = 250.0  # Maximum velocity
	
	var logVelocity = minVelocity + (maxVelocity - minVelocity) * (1.0 - exp(-mobSpeedGrowth * score))
	
	var velocity: Vector2 = Vector2(logVelocity, 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_hud_start_game() -> void:
	new_game()
