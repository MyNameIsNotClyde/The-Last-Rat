@abstract class_name Weapon extends Node2D

enum TARGET_MODE { NONE, RANDOM, CLOSEST }
# Target mode "none": Does not aim at an enemy (custom logic)
# Target mode "random": Aims at a random enemy
# Target mode "closest": Aims at the closest enemy

var level: int = 0 # Level for upgradable weapons
var ammo: int # Current number of shots remaining
var max_ammo: int # Number of shots after reload
var shoot_time: float # Time between shots, in seconds
var reload_time: float # Time for reload
var target_mode: TARGET_MODE
var target_range: int # Maximum range when the weapon starts firing, ignored when target_mode is none
var projectile: Resource # that is a Projectile class
var proj_durability: int
var proj_speed: int
var proj_angle: Vector2
var proj_damage: int
var proj_kb_power: int
var proj_size: float

func _ready() -> void:
	ammo = max_ammo
	var reloadTimer = Timer.new()
	reloadTimer.name = "ReloadTimer"
	reloadTimer.wait_time = reload_time
	reloadTimer.one_shot = true
	add_child(reloadTimer)
	$ReloadTimer.connect("timeout", Callable(self, "reload"))
	if max_ammo <= 1: return
	var shootTimer = Timer.new()
	shootTimer.name = "ShootTimer"
	shootTimer.wait_time = shoot_time
	shootTimer.one_shot = true
	add_child(shootTimer)

@abstract func set_level(new_level: int)
@abstract func shoot(target: Node2D)
@abstract func reload()
