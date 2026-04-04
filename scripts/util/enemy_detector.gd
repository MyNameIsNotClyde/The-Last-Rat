extends Area2D

var enemies_detected: Array[Node2D] = []

func _on_body_entered(body: Node2D) -> void:
	if not enemies_detected.has(body):
		enemies_detected.append(body)

func _on_body_exited(body: Node2D) -> void:
	if enemies_detected.has(body):
		enemies_detected.erase(body)

func get_random_enemy() -> Node2D:
	if enemies_detected.size() == 0: return null
	return enemies_detected.pick_random()

func sort_by_dist(a, b):
	return global_position.distance_to(a.global_position) <= global_position.distance_to(b.global_position)

func get_closest_enemy() -> Node2D:
	if enemies_detected.size() == 0: return null
	enemies_detected.sort_custom(sort_by_dist)
	return enemies_detected[0]
