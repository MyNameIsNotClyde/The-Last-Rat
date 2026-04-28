extends Weapon

func _ready() -> void:
	weapon_name = "Crossbow"
	weapon_icon = preload("res://assets/sprites/upgrades/crossbow.png")
	target_mode = TARGET_MODE.RANDOM
	target_range = 200
	projectile = preload("res://scripts/weapons/arrow.tscn")
	base_stats = {
		"max_ammo": 1,
		"shoot_time": 0.0,
		"reload_time": 1.2,
		"proj_damage": 10.0,
		"proj_speed": 200.0,
		"proj_durability": 99,
		"proj_kb_power": 50.0,
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
		"description": "Better bolt design doubles knockback with no loss in piercing power.",
		"effects": {
			"proj_kb_power": 100
		}
	},
	{
		"level": 3,
		"description": "Even better bolt design improves projectile speed by 50%.",
		"effects": {
			"proj_speed": 300
		}
	},
	{
		"level": 4,
		"description": "Shoots an additional weaker bolt at the same time.",
		"effects": {
			"max_ammo": 2
		}
	},
]

func shoot(target: Node2D):
	if target == null: return # Check if there is a target
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return
	for i in range(ammo):
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
	ammo = 0
	$ShootSound.play()
	$ReloadTimer.start(reload_time)

func reload() -> void:
	$ReloadSound.play()

func _on_reload_sound_finished() -> void:
	ammo = max_ammo
