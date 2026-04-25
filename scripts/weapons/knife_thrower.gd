extends Weapon

@onready var player = get_tree().get_first_node_in_group("player")
var shoot_angle = Vector2(1,0)

func _ready() -> void:
	weapon_name = "Knives"
	weapon_icon = preload("res://assets/sprites/upgrades/knife.png")
	max_ammo = 1
	shoot_time = 0.2
	reload_time = 1.0
	target_mode = TARGET_MODE.NONE
	projectile = preload("res://scripts/weapons/knife.tscn")
	proj_durability = 1
	proj_speed = 200
	proj_damage = 10.0
	proj_kb_power = 80
	proj_size = 1.0
	super()

const UPGRADE_TABLE = {
	1: {
		"level": 1,
		"description": "Throw knives in the direction you move.",
		"effects": {}
	},
	2: {
		"level": 2,
		"description": "Throw an additional knife. Knives are now 25% faster.",
		"effects": {
			"max_ammo": 2,
			"proj_speed": 250
		}
	},
	3: {
		"level": 3,
		"description": "Throw an additional knife. Knives now knock back enemies more by 25%.",
		"effects": {
			"max_ammo": 3,
			"proj_kb_power": 100
		}
	},
	4: {
		"level": 4,
		"description": "Throw an additional knife. Knives now pierces through 1 enemy.",
		"effects": {
			"max_ammo": 4,
			"proj_durability": 2
		}
	},
}

func upgrade_to(new_level: int):
	if (level >= new_level): return
	for i in range(level, new_level):
		var upgrade_effects = UPGRADE_TABLE[i+1]["effects"]
		for property in upgrade_effects:
			set(property, upgrade_effects[property])
	level = new_level

func _physics_process(_delta: float) -> void:
	if player.velocity.is_zero_approx(): return
	shoot_angle = player.velocity.normalized()

func shoot(_target: Node2D):
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return
	if not $ShootTimer.is_stopped(): return
	proj_angle = player.velocity.normalized()
	var knife: Projectile = projectile.instantiate()
	var random_pos = Vector2.ZERO
	if ammo != max_ammo:
		random_pos.x = randf_range(-10.0, 10.0)
		random_pos.y = randf_range(-10.0, 10.0)
	knife.set_props(
		global_position + random_pos,
		shoot_angle,
		proj_speed,
		proj_durability,
		proj_damage,
		proj_kb_power,
		proj_size
	)
	add_child(knife)
	ammo -= 1
	$ReloadTimer.start()
	$ShootTimer.start()
	$ThrowSound.play()

func reload():
	ammo = max_ammo
