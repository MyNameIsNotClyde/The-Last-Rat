extends Area2D

signal hit
@export var speed = 400
var health
@export var max_health = 100
var screen_size
var is_dead: bool

func _ready() -> void:
	screen_size = get_viewport_rect().size
	#hide()

func _process(delta: float) -> void:
	if is_dead: return
	var vel = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	if Input.is_action_pressed("move_down"):
		vel.y += 1
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
	if Input.is_action_pressed("move_right"):
		vel.x += 1
	
	if vel.length() > 0:
		vel = vel.normalized() * speed
		position += vel * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		$Sprites.play()
	else:
		$Sprites.stop()
	if vel.x < 0:
		$Sprites.flip_h = true
	elif vel.x > 0:
		$Sprites.flip_h = false

func _on_body_entered(_body: Node2D) -> void:
	health -= 25
	$HealthBar.value = health * 100 / max_health
	if health > 0: return
	is_dead = true
	hide()
	hit.emit()
	$Hitbox.set_deferred("disabled", true)

func start(pos: Vector2):
	position = pos
	is_dead = false
	health = 100
	$HealthBar.value = 100
	show()
	$Hitbox.disabled = false
