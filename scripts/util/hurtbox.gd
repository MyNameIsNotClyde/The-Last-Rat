extends Area2D

@export_enum("Cooldown", "HitOnce", "DisableHitbox") var hurtboxType = 0
var hit_once_record: Array[Area2D] = []

signal hurt(damage, kb_power, kb_angle)

func _on_area_entered(area: Area2D) -> void:
	if not area.is_in_group("attack"): return
	if area.get("damage") == null: return
	match hurtboxType:
		0: #Cooldown - After hit, this hurtbox will not be hit again until cooldown ends
			$CollisionShape2D.call_deferred("set", "disabled", true)
			$DisableTimer.start()
		1: #HitOnce - After hit, this hurtbox will not be hit by the same hitbox again
			if hit_once_record.has(area): return
			hit_once_record.append(area)
			if not area.has_signal("node_freed"):
				print('Warning: Object %s has no node_freed signal.'%area.name)
				return
			if area.is_connected("node_freed", Callable(self, "remove_from_record")): return
			area.connect("node_freed", Callable(self, "remove_from_record"))
		2: #DisableHitbox - After hit, the hitbox (not this hurtbox) will be disabled for a cooldown
			if area.has_method("tempDisable"): area.tempDisable()
	var damage = area.damage
	var kb_angle = Vector2.ZERO
	var kb_power = 0
	if area.get("angle") != null: kb_angle = area.angle
	if area.get("kb_power") != null: kb_power = area.kb_power
	emit_signal("hurt", damage, kb_power, kb_angle)
	if area.has_method("enemy_hit"): area.enemy_hit(1)

func remove_from_record(obj: Area2D) -> void:
	if not hit_once_record.has(obj): return
	hit_once_record.erase(obj)

func _on_disable_timer_timeout() -> void:
	$CollisionShape2D.call_deferred("set","disabled", false)
