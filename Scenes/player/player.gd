extends Area2D

signal hit

@export var speed: float = 400
var screen_size: Vector2

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _ready() -> void:
	hide()
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocity = _playerVelocity()
	_animateMovement(velocity)
	_move(velocity, delta)

func _animateMovement(velocity: Vector2) -> void:
	var animatedSprite:AnimatedSprite2D = $AnimatedSprite2D
	
	if velocity.x != 0:
		animatedSprite.animation = "walk"
		animatedSprite.flip_v = false
		animatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animatedSprite.animation = "up"
		animatedSprite.flip_v = velocity.y > 0
		
	if(velocity.length() > 0):
		animatedSprite.play()
	else:
		animatedSprite.stop()
		
func _move(velocity: Vector2, delta: float):
	if(velocity.length() > 0): 
		velocity = velocity.normalized() * speed
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
		
func _playerVelocity() -> Vector2:
	var velocity: Vector2 = Vector2.ZERO
	if Input.is_action_pressed('move_left'):
		velocity.x -= 1
	if Input.is_action_pressed('move_up'):
		velocity.y -= 1
	if Input.is_action_pressed('move_right'):
		velocity.x += 1
	if Input.is_action_pressed('move_down'):
		velocity.y += 1
	return velocity
	
func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
