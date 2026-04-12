extends Weapon

@onready var player = get_tree().get_first_node_in_group("player")
var shoot_angle = Vector2(1,0)

func _ready() -> void:
	max_ammo = 1
	reload_time = 1.0
	target_mode = TARGET_MODE.NONE
	projectile = preload("res://scripts/weapons/knife.tscn")
	super()

func set_level(new_level: int):
	level = new_level
	match level:
		1:
			proj_durability = 1
			proj_speed = 200
			proj_damage = 10
			proj_kb_power = 100
			proj_size = 1.0

func _physics_process(_delta: float) -> void:
	if player.velocity.is_zero_approx(): return
	shoot_angle = player.velocity.normalized()

func shoot(_target: Node2D):
	if level <= 0: return # Check if player has weapon
	if ammo <= 0: return
	proj_angle = player.velocity.normalized()
	var knife: Projectile = projectile.instantiate()
	knife.set_props(
		global_position,
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
	$ThrowSound.play()

func reload():
	ammo = max_ammo
