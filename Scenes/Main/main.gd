extends Node

@export var mob_scene: PackedScene
var score: float = 0.0
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Hud.show_game_over()
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
	var mob: Node2D  = mob_scene.instantiate()
	
	var mob_spawn_location:PathFollow2D = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	var direction: float = mob_spawn_location.rotation + PI / 2
	
	mob.position = mob_spawn_location.position
	
	direction += randf_range(-PI / 4, PI /4 )
	mob.rotation = direction
	
	var velocity: Vector2 = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)

func _on_hud_start_game() -> void:
	new_game()
