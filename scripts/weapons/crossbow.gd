extends Weapon

func _ready() -> void:
	weapon_name = "Crossbow"
	weapon_icon = preload("res://assets/sprites/upgrades/crossbow.png")
	target_mode = TARGET_MODE.RANDOM
	target_range = 200
	projectile = preload("res://scripts/weapons/arrow.tscn")
	base_stats = {
		"max_ammo": 1,
		"shoot_time": 0.4,
		"reload_time": 1.2,
		"trailing_shots": 1,
		"proj_damage": 8.0,
		"proj_speed": 300.0,
		"proj_durability": 99,
		"proj_kb_power": 80.0,
		"proj_size": 1.0
	}
	super()

const UPGRADE_TABLE = [
	{
		"level": 1,
		"description": "A medium-range crossbow that shoot a piercing bolt at random targets.",
		"effects": {}
	},
	{
		"level": 2,
		"description": "Better bolt design increases knockback by 25% and damage by 50%.",
		"effects": {
			"proj_kb_power": 100,
			"proj_damage": 12.0,
		}
	},
	{
		"level": 3,
		"description": "Repeater design allows for an extra shot before reloading.",
		"effects": {
			"max_ammo": 2
		}
	},
	{
		"level": 4,
		"description": "Shoots an additional weaker bolt at the same time.",
		"effects": {
			"trailing_shots": 2
		}
	},
]

func shoot(target: Node2D):
	if target == null: return # Check if there is a target
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return
	if not $ShootTimer.is_stopped(): return # Check weapon shoot cooldown
	var trailing_shots = base_stats["trailing_shots"]
	for i in range(trailing_shots):
		var arrow: Projectile = projectile.instantiate()
		arrow.set_props(
			global_position,
			global_position.direction_to(target.global_position),
			float(proj_speed)/(i+1),
			proj_durability,
			float(proj_damage)/(i+1),
			proj_kb_power,
			proj_size
		)
		add_child(arrow)
	ammo -= 1
	$ShootSound.play()
	$ShootTimer.start(shoot_time)
	$ReloadTimer.start(reload_time)

func reload() -> void:
	$ReloadSound.play()

func _on_reload_sound_finished() -> void:
	ammo = max_ammo
