extends Weapon

var proj_duration: float
var proj_damage_interval: float

func _ready() -> void:
	max_ammo = 1
	reload_time = 2.0
	target_mode = TARGET_MODE.RANDOM
	target_range = 100
	projectile = preload("res://scripts/weapons/poison_vial.tscn")
	proj_durability = 0
	proj_speed = 100
	proj_kb_power = 0
	super()

func set_level(new_level: int):
	level = new_level
	match level:
		1:
			proj_duration = 3.0
			proj_damage = 1
			proj_damage_interval = 0.15
			proj_size = 1.0

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
	$ReloadTimer.start()

func reload():
	ammo = max_ammo
