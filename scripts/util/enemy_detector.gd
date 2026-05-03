extends Area2D

var enemies_detected: Array[Node2D] = []

func _on_area_entered(area: Node2D) -> void:
	if not enemies_detected.has(area):
		enemies_detected.append(area)

func _on_area_exited(area: Node2D) -> void:
	if enemies_detected.has(area):
		enemies_detected.erase(area)

func get_random_enemy(target_range: int) -> Node2D:
	var enemies_in_range = enemies_detected.filter(
		func(enemy): return global_position.distance_to(enemy.global_position) <= target_range
	)
	if enemies_in_range.size() == 0: return null
	return enemies_in_range.pick_random()

func sort_by_dist(a, b):
	return global_position.distance_to(a.global_position) <= global_position.distance_to(b.global_position)

func get_closest_enemy(target_range: int) -> Node2D:
	if enemies_detected.size() == 0: return null
	enemies_detected.sort_custom(sort_by_dist)
	if global_position.distance_to(enemies_detected[0].global_position) > target_range: return null
	return enemies_detected[0]
