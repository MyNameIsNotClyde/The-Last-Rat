extends Node2D

@export var spawns: Array[SpawnInfo] = []
@onready var player = get_tree().get_first_node_in_group("player")

var time = 0

func _process(delta: float) -> void:
	time += delta
	for info in spawns:
		if time >= info.time_start and time <= info.time_end:
			if time >= info.spawn_next:
				spawn_enemy(info)
				info.spawn_next = time + info.spawn_interval

func spawn_enemy(info: SpawnInfo):
	for i in range(info.spawn_amount):
		var spawned_enemy = info.enemy.instantiate()
		spawned_enemy.global_position = generate_random_edge_position()
		add_child(spawned_enemy)

func generate_random_edge_position():
	$Path2D/PathFollow2D.progress_ratio = randf()
	return player.global_position + $Path2D/PathFollow2D.position
	
