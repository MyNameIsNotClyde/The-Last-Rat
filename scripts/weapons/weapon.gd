@abstract class_name Weapon extends Node2D

enum TARGET_MODE { NONE, RANDOM, CLOSEST }
# Target mode "none": Does not aim at an enemy (custom logic)
# Target mode "random": Aims at a random enemy
# Target mode "closest": Aims at the closest enemy

var level: int # Level for upgradable weapons
var ammo: int # Current number of shots remaining
var max_ammo: int # Number of shots after reload
var shoot_time: float # Time between shots, in seconds
var reload_time: float # Time for reload
var target_mode: TARGET_MODE
var projectile: Resource # that is a Projectile class
var proj_durability: int
var proj_speed: int
var proj_angle: Vector2
var proj_damage: int
var proj_kb_power: int
var proj_size: float

@warning_ignore("shadowed_variable")
func _init(max_ammo: int, shoot_time: float, reload_time: float, 
		target_mode: TARGET_MODE, projectile: Resource) -> void:
	self.level = 0
	self.ammo = max_ammo
	self.max_ammo = max_ammo
	self.shoot_time = shoot_time
	self.reload_time = reload_time
	self.target_mode = target_mode
	self.projectile = projectile
	var reloadTimer = Timer.new()
	reloadTimer.name = "ReloadTimer"
	reloadTimer.wait_time = reload_time
	reloadTimer.one_shot = true
	add_child(reloadTimer)
	$ReloadTimer.connect("timeout", Callable(self, "reload"))
	if max_ammo == 1: return
	var shootTimer = Timer.new()
	shootTimer.name = "ShootTimer"
	shootTimer.wait_time = shoot_time
	shootTimer.one_shot = true
	add_child(shootTimer)

func set_projectile_vars(proj: Projectile):
	proj.global_position = global_position
	proj.angle = proj_angle
	proj.durability = proj_durability
	proj.speed = proj_speed
	proj.damage = proj_damage
	proj.kb_power = proj_kb_power
	proj.size = proj_size

@abstract func shoot(target: Node2D)
@abstract func reload()
