extends Node2D

var level: int = 1 # Level for upgradable weapons
var ammo: int # Current number of shots remaining
@export var max_ammo: int = 2 # Number of shots after reload
@export var shoot_time: float = 0.8 # Time between shots
@export var reload_time: float = 2.0 # Time for reload
@export_enum("none", "random", "closest") var target_mode = 2
@export var spread_angle: float = 10
@export var spread_amount: int = 5

@export var projectile: Resource
var proj_angle = Vector2.ZERO # Projectile travel direction
var proj_durability = 1 # Projectile pierce
var proj_speed = 400 # Projectile speed
var proj_damage = 5 # Projectile damage
var proj_knockback = 100 # Projectile knockback
var proj_size = 1.0 # Projectile size scaler

func _ready() -> void:
	match level:
		1:
			proj_durability = 1
			proj_speed = 400
			proj_damage = 5
			proj_knockback = 100
			proj_size = 1.0
	ammo = max_ammo
	$ShootTimer.wait_time = shoot_time
	$ReloadTimer.wait_time = reload_time

func shoot(target):
	if target == null: return # Check if there is a target
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return # Check if weapon has ammo
	if not $ShootTimer.is_stopped(): return # Check weapon shoot cooldown
	proj_angle = global_position.direction_to(target.global_position)
	@warning_ignore("integer_division")
	var offset = spread_amount / 2
	for i in range(-offset, offset+1):
		var bullet = projectile.instantiate()
		bullet.global_position = global_position
		bullet.angle = proj_angle.rotated(deg_to_rad(spread_angle*i))
		bullet.durability = proj_durability
		bullet.speed = proj_speed
		bullet.damage = proj_damage
		bullet.knockback = proj_knockback
		bullet.size = proj_size
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
