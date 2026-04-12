extends Weapon

func _ready() -> void:
	max_ammo = 1
	reload_time = 1.2
	target_mode = TARGET_MODE.RANDOM
	target_range = 200
	projectile = preload("res://scripts/weapons/arrow.tscn")
	super()

func set_level(new_level: int):
	level = new_level
	match level:
		1:
			proj_durability = 99
			proj_speed = 200
			proj_damage = 10
			proj_kb_power = 100
			proj_size = 1.0

func shoot(target: Node2D):
	if target == null: return # Check if there is a target
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return
	var arrow: Projectile = projectile.instantiate()
	arrow.set_props(
		global_position,
		global_position.direction_to(target.global_position),
		proj_speed,
		proj_durability,
		proj_damage,
		proj_kb_power,
		proj_size
	)
	add_child(arrow)
	ammo -= 1
	$ShootSound.play()
	$ReloadTimer.start()

func reload() -> void:
	$ReloadSound.play()

func _on_reload_sound_finished() -> void:
	ammo = max_ammo
