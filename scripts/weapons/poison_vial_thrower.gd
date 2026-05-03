extends Weapon

var proj_duration: float
var proj_damage_interval: float

func _ready() -> void:
	weapon_name = "Poison Vials"
	weapon_icon = preload("res://assets/sprites/upgrades/poison_vial.png")
	target_mode = TARGET_MODE.RANDOM
	target_range = 150
	projectile = preload("res://scripts/weapons/poison_vial.tscn")
	base_stats = {
		"max_ammo": 1,
		"shoot_time": 0.4,
		"reload_time": 2.0,
		"proj_damage": 2.0,
		"proj_damage_interval": 0.5,
		"proj_duration": 3.0,
		"proj_speed": 100.0,
		"proj_durability": 0.0,
		"proj_kb_power": 0,
		"proj_size": 1.0
	}
	super()

const UPGRADE_TABLE = [
	{
		"level": 1,
		"description": "Throw a vial of poison that lingers on the ground.",
		"effects": {}
	},
	{
		"level": 2,
		"description": "The pool of poison lasts 50% longer. The vial travels 60% faster.",
		"effects": {
			"proj_duration": 4.5,
			"proj_speed": 160.0
		}
	},
	{
		"level": 3,
		"description": "Better poison formula increases both damage and damage rate by 25%.",
		"effects": {
			"proj_damage": 2.5,
			"proj_damage_interval": 0.4
		}
	},
	{
		"level": 4,
		"description": "An added accelerant increases the poison damage rate by 33%.",
		"effects": {
			"proj_damage_interval": 0.3
		}
	}
]

func shoot(target: Node2D):
	if target == null: return # Check if there is a target
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return # Check if weapon has ammo
	if not $ShootTimer.is_stopped(): return # Check weapon shoot cooldown
	var vial: Projectile = projectile.instantiate()
	vial.set_props(
		global_position,
		Vector2.ZERO,
		proj_speed,
		proj_durability,
		proj_damage,
		proj_kb_power,
		proj_size
	)
	vial.target_position = target.global_position
	vial.duration = proj_duration
	vial.damage_interval = proj_damage_interval
	add_child(vial)
	ammo -= 1
	$ThrowSound.play()
	$ShootTimer.start(shoot_time)
	$ReloadTimer.start(reload_time)

func reload():
	ammo = max_ammo
