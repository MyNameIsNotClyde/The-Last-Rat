extends Node2D

@export var spawns: Array[SpawnInfo] = []
@onready var player = get_tree().get_first_node_in_group("player")

var time = 0

func _on_spawn_timer_timeout() -> void:
	time += 1
	var enemy_spawns = spawns
	for info in enemy_spawns:
		if time >= info.time_start and time <= info.time_end:
			if info.spawn_time_counter == 0: spawn_enemy(info)
			info.spawn_time_counter += 1
			if info.spawn_interval != 0: info.spawn_time_counter %= info.spawn_interval

func spawn_enemy(info: SpawnInfo):
	var counter_amount = 0
	while counter_amount < info.spawn_amount:
		var spawned_enemy = info.enemy.instantiate()
		spawned_enemy.global_position = generate_random_edge_position()
		add_child(spawned_enemy)
		counter_amount += 1

func generate_random_edge_position():
	$Path2D/PathFollow2D.progress_ratio = randf()
	return player.global_position + $Path2D/PathFollow2D.position
	
