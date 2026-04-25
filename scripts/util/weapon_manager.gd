extends Node2D

var weapons = {}
var detector: Area2D

func _ready():
	for weapon in UpgradeDB.WEAPON_LIST:
		var new_weapon = UpgradeDB.WEAPON_LIST[weapon].instantiate()
		weapons[weapon] = new_weapon
		add_child(new_weapon)

func attack():
	for weapon_name in weapons:
		var weapon = weapons[weapon_name]
		match weapon.target_mode:
			Weapon.TARGET_MODE.NONE:
				weapon.shoot(null)
			Weapon.TARGET_MODE.RANDOM:
				weapon.shoot(detector.get_random_enemy(weapon.target_range))
			Weapon.TARGET_MODE.CLOSEST:
				weapon.shoot(detector.get_closest_enemy(weapon.target_range))
