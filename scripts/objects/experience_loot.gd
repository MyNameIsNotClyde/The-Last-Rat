extends Area2D

@export var experience_amount = 1
var target = null
var speed = -2
var accel = 4

func _ready() -> void:
	if experience_amount < 5: return
	elif experience_amount < 25: $Sprite2D.frame = 1
	else: $Sprite2D.frame = 2

func _physics_process(delta: float) -> void:
	if target == null: return
	global_position = global_position.move_toward(target.global_position, speed)
	speed += accel*delta

func collect():
	$CollectSound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.visible = false
	return experience_amount

func _on_collect_sound_finished() -> void:
	queue_free()
