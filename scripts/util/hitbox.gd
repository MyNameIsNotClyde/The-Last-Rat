extends Area2D

@export var damage = 1

func tempDisable():
	$CollisionShape2D.call_deferred("set", "disabled", true)
	$DisableTimer.start()


func _on_disable_timer_timeout() -> void:
	$CollisionShape2D.call_deferred("set", "disabled", false)
