extends Projectile

func _physics_process(delta: float) -> void:
	position += angle*speed*delta

func _on_despawn_timer_timeout() -> void:
	emit_signal("node_freed", self)
	queue_free()
