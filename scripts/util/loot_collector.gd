extends Node2D

signal exp_gain(amount: int)
signal gold_gain(amount: int)

func _on_attract_area_area_entered(area: Area2D) -> void:
	if not area.is_in_group("loot"): return
	area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if not area.is_in_group("loot"): return
	if "gold_amount" in area:
		emit_signal("gold_gain",area.collect())
	if "experience_amount" in area:
		emit_signal("exp_gain",area.collect())
