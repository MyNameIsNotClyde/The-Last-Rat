extends CharacterBody2D

@export var speed = 100
@export var max_health = 100
var health = 80
var weapons: Array[Weapon] = []

func _ready() -> void:
	add_weapon("shotgun", 1)
	add_weapon("crossbow", 1)

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = velocity.normalized()*speed
	if velocity.x > 0: $Sprite2D.flip_h = false
	if velocity.x < 0: $Sprite2D.flip_h = true
	if velocity.length() > 0:
		if $WalkTimer.is_stopped():
			$Sprite2D.frame = ($Sprite2D.frame + 1) % $Sprite2D.hframes
			$WalkTimer.start()
	else:
		$Sprite2D.frame = 0
	
	move_and_slide()

func _process(_delta: float) -> void:
	attack()

func attack():
	for weapon in weapons:
		match weapon.target_mode:
			Weapon.TARGET_MODE.NONE:
				weapon.shoot(null)
			Weapon.TARGET_MODE.RANDOM:
				weapon.shoot($EnemyDetector.get_random_enemy())
			Weapon.TARGET_MODE.CLOSEST:
				weapon.shoot($EnemyDetector.get_closest_enemy())

func _on_hurtbox_hurt(damage: int, _kb_power, _kb_angle) -> void:
	health -= damage
	print(health)

func add_weapon(weapon_name: String, level: int):
	var weapon = load("res://scripts/weapons/%s.tscn"%weapon_name).instantiate()
	weapon.level = level
	add_child(weapon)
	weapons.append(weapon)
