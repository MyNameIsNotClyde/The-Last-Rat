extends Resource

class_name SpawnInfo
@export var time_start: float
@export var time_end: float
@export var enemy: Resource
@export var spawn_amount: int
@export var spawn_interval: float

var spawn_next: float = 0.0
