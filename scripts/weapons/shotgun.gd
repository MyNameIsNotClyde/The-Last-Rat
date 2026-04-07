extends Weapon

var spread_angle: float
var spread_amount: int

func _init() -> void:
	spread_angle = 10.0
	spread_amount = 5
	var weapon_max_ammo = 2
	var weapon_shoot_time = 0.8
	var weapon_reload_time = 2.0
	var weapon_target_mode = TARGET_MODE.CLOSEST
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
			proj_durability = 1
			proj_speed = 400
			proj_damage = 5
			proj_kb_power = 100
			proj_size = 1.0

func shoot(target: Node2D):
	if target == null: return # Check if there is a target
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return # Check if weapon has ammo
	if not $ShootTimer.is_stopped(): return # Check weapon shoot cooldown
	proj_angle = global_position.direction_to(target.global_position)
	@warning_ignore("integer_division")
	var offset = spread_amount / 2
	for i in range(-offset, offset+1):
		var bullet: Projectile = projectile.instantiate()
		set_projectile_vars(bullet)
		bullet.angle = proj_angle.rotated(deg_to_rad(spread_angle*i))
		add_child(bullet)
	ammo -= 1
	$ShootSound.play()
	$ShootTimer.start()
	$ReloadTimer.start()

func reload():
	ammo = 0
	$ReloadSound.play()

func _on_reload_sound_finished() -> void:
	ammo = max_ammo
