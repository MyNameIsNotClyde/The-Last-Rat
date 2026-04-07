extends Weapon

func _init():
	var weapon_max_ammo = 1
	var weapon_shoot_time = 0
	var weapon_reload_time = 1.2
	var weapon_target_mode = TARGET_MODE.RANDOM
	var weapon_projectile = preload("res://scripts/weapons/bullet.tscn")
	super(
		weapon_max_ammo,
		weapon_shoot_time,
		weapon_reload_time,
		weapon_target_mode,
		weapon_projectile
		)

func _ready() -> void:
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
	proj_angle = global_position.direction_to(target.global_position)
	var arrow: Projectile = projectile.instantiate()
	arrow.global_position = global_position
	arrow.angle = proj_angle
	set_projectile_vars(arrow)
	add_child(arrow)
	ammo -= 1
	$ShootSound.play()
	$ReloadTimer.start()

func reload() -> void:
	$ReloadSound.play()

func _on_reload_sound_finished() -> void:
	ammo = max_ammo
