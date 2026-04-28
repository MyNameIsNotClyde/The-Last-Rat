@abstract class_name Weapon extends Node2D

enum TARGET_MODE { NONE, RANDOM, CLOSEST }
# Target mode "none": Does not aim at an enemy (custom logic)
# Target mode "random": Aims at a random enemy
# Target mode "closest": Aims at the closest enemy

var weapon_name: String
var weapon_icon: Resource
var level: int = 0 # Level for upgradable weapons
var ammo: int # Current number of shots remaining
var max_ammo: int # Number of shots after reload
var shoot_time: float # Time between shots, in seconds
var reload_time: float # Time for reload
var target_mode: TARGET_MODE
var target_range: int # Maximum range when the weapon starts firing, ignored when target_mode is none
var projectile: Resource # that is a Projectile class
var proj_durability: int
var proj_speed: float
var proj_angle: Vector2
var proj_damage: float
var proj_kb_power: float
var proj_size: float
var base_stats: Dictionary # The base values for above variables, before player stats modify
#const UPGRADE_TABLE # The upgrade table is a dict with level (int) as key

func _ready() -> void:
	update_stats()
	ammo = max_ammo
	var reloadTimer = Timer.new()
	reloadTimer.name = "ReloadTimer"
	reloadTimer.wait_time = reload_time
	reloadTimer.one_shot = true
	add_child(reloadTimer)
	$ReloadTimer.connect("timeout", Callable(self, "reload"))
	if shoot_time == 0: return
	var shootTimer = Timer.new()
	shootTimer.name = "ShootTimer"
	shootTimer.wait_time = shoot_time
	shootTimer.one_shot = true
	add_child(shootTimer)

func update_stats(player_obj=null):
	for stat in base_stats: set(stat, base_stats[stat])
	if player_obj != null:
		proj_damage *= player_obj.might
		proj_speed *= player_obj.dexterity
		proj_size *= player_obj.area
		shoot_time *= player_obj.cooldown
		reload_time *= player_obj.cooldown
		max_ammo += player_obj.multi

func upgrade_to(new_level: int):
	if (level >= new_level): return
	for i in range(level, new_level):
		var upgrade_effects = self.UPGRADE_TABLE[i]["effects"]
		for stat in upgrade_effects:
			base_stats[stat] = upgrade_effects[stat]
	level = new_level

@abstract func shoot(target: Node2D)
@abstract func reload()
