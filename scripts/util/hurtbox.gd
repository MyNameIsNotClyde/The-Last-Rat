extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitbox") var hurtboxType = 0
signal hurt(damage)

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("attack"): return
	if area.get("damage") == null: return
	match hurtboxType:
		0: #Cooldown
			$CollisionShape2D.call_deferred("set", "disabled", true)
			$DisableTimer.start()
		1: #HitOnce
			pass
		2: #DisableHitbox
			if area.has_method("tempDisable"): area.tempDisable()
	var damage = area.damage
	emit_signal("hurt", damage)
	if area.has_method("enemy_hit"): area.enemy_hit(1)

func _on_disable_timer_timeout() -> void:
	$CollisionShape2D.call_deferred("set","disabled", false)
