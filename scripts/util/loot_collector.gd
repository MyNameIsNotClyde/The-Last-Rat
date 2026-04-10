extends Node2D

signal exp_gain(amount: int)

func _on_attract_area_area_entered(area: Area2D) -> void:
	if not area.is_in_group("loot"): return
	area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if not area.is_in_group("loot"): return
	emit_signal("exp_gain",area.collect())
