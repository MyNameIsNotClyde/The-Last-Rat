extends Weapon

var shoot_angle = Vector2(1,0)
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	weapon_name = "Knives"
	weapon_icon = preload("res://assets/sprites/upgrades/knife.png")
	target_mode = TARGET_MODE.NONE
	projectile = preload("res://scripts/weapons/knife.tscn")
	base_stats = {
		"max_ammo": 1,
		"shoot_time": 0.2,
		"reload_time": 1.0,
		"proj_damage": 10.0,
		"proj_speed": 200.0,
		"proj_durability": 1,
		"proj_kb_power": 80.0,
		"proj_size": 1.0
	}
	super()

const UPGRADE_TABLE = [
	{
		"level": 1,
		"description": "Throw knives in the direction you move.",
		"effects": {}
	},
	{
		"level": 2,
		"description": "Throw an additional knife. Knives have 25% more speed and knockback power.",
		"effects": {
			"max_ammo": 2,
			"proj_speed": 250,
			"proj_kb_power": 100
		}
	},
	{
		"level": 3,
		"description": "Throw an additional knife. Throw knives behind you as well.",
		"effects": {
			"max_ammo": 3
		}
	},
	{
		"level": 4,
		"description": "Throw an additional knife. Knives now pierces through 1 enemy.",
		"effects": {
			"max_ammo": 4,
			"proj_durability": 2
		}
	}
]

func _physics_process(_delta: float) -> void:
	if player.velocity.is_zero_approx(): return
	shoot_angle = player.velocity.normalized()

func shoot(_target: Node2D):
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return
	if not $ShootTimer.is_stopped(): return
	var throw_knife = func(angle_offset=0):
		var knife: Projectile = projectile.instantiate()
		var random_pos = Vector2.ZERO
		if ammo != max_ammo:
			random_pos.x = randf_range(-10.0, 10.0)
			random_pos.y = randf_range(-10.0, 10.0)
		knife.set_props(
			global_position + random_pos,
			shoot_angle.rotated(angle_offset),
			proj_speed,
			proj_durability,
			proj_damage,
			proj_kb_power,
			proj_size
		)
		add_child(knife)
	throw_knife.call()
	if (level >= 3): throw_knife.call(deg_to_rad(180))
	ammo -= 1
	$ReloadTimer.start(reload_time)
	$ShootTimer.start(shoot_time)
	$ThrowSound.play()

func reload():
	ammo = max_ammo
