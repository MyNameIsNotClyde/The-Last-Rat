extends Area2D

@export var gold_amount = 1
var target = null
var speed = 0
var accel = 4

func _physics_process(delta: float) -> void:
	if target == null: return
	global_position = global_position.move_toward(target.global_position, speed)
	speed += accel*delta

func collect():
	$SoundCollect.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.visible = false
	return gold_amount

func _on_audio_stream_player_finished() -> void:
	queue_free()
