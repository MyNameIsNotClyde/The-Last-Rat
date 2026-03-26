extends Area2D

signal hit
@export var speed = 400
var screen_size
var is_dead: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	#hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if vel.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif vel.x > 0:
		$AnimatedSprite2D.flip_h = false

func _on_body_entered(body: Node2D) -> void:
	is_dead = true
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos: Vector2):
	position = pos
	is_dead = false
	show()
	$CollisionShape2D.disabled = false
