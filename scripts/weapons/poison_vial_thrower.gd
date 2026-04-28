extends Weapon

var proj_duration: float
var proj_damage_interval: float

func _ready() -> void:
	weapon_name = "Poison Vials"
	weapon_icon = preload("res://assets/sprites/upgrades/poison_vial.png")
	target_mode = TARGET_MODE.RANDOM
	target_range = 100
	projectile = preload("res://scripts/weapons/poison_vial.tscn")
	base_stats = {
		"max_ammo": 1,
		"shoot_time": 0.4,
		"reload_time": 2.0,
		"proj_damage": 3.0,
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
		"description": "Increase the range of the throw by 50%.",
		"effects": {
			"target_range" = 150
		}
	},
	{
		"level": 3,
		"description": "The pool of poison lasts 50% longer.",
		"effects": {
			"proj_duration": 4.5
		}
	},
	{
		"level": 4,
		"description": "An added accelerant increases the poison damage rate by 33%.",
		"effects": {
			"proj_damage_interval": 0.4,
		}
	}
]

func shoot(target: Node2D):
	if target == null: return # Check if there is a target
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return # Check if weapon has ammo
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
