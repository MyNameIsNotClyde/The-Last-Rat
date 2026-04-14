extends CharacterBody2D

@export var speed = 100
@export var max_health = 100
var health = 80
var weapons: Array[Weapon] = []
var experience = 0
var level = 1

func _ready() -> void:
	set_exp_bar(experience, get_xp_lvl_up_req())
	add_weapon("shotgun", 1)
	add_weapon("crossbow", 1)
	add_weapon("knife_thrower", 1)
	add_weapon("poison_vial_thrower", 1)

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = velocity.normalized()*speed
	if velocity.x > 0: $Sprite2D.flip_h = false
	if velocity.x < 0: $Sprite2D.flip_h = true
	if velocity.length() > 0:
		if $Sprite2D/WalkTimer.is_stopped():
			$Sprite2D.frame = ($Sprite2D.frame + 1) % $Sprite2D.hframes
			$Sprite2D/WalkTimer.start()
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
				weapon.shoot($EnemyDetector.get_random_enemy(weapon.target_range))
			Weapon.TARGET_MODE.CLOSEST:
				weapon.shoot($EnemyDetector.get_closest_enemy(weapon.target_range))

func _on_hurtbox_hurt(damage: int, _kb_power, _kb_angle) -> void:
	health -= damage
	print(health)

func add_weapon(weapon_name: String, weapon_level: int):
	var weapon = load("res://scripts/weapons/%s.tscn"%weapon_name).instantiate()
	weapon.set_level(weapon_level)
	add_child(weapon)
	weapons.append(weapon)

func _on_loot_collector_exp_gain(amount: int) -> void:
	var experience_needed_to_level_up = get_xp_lvl_up_req()
	var level_before_collect = level
	experience += amount
	while experience >= experience_needed_to_level_up:
		# Level up
		level += 1
		$%LevelLabel.text = str("Level ",level)
		experience -= experience_needed_to_level_up
		experience_needed_to_level_up = get_xp_lvl_up_req()
	set_exp_bar(experience, experience_needed_to_level_up)
	$%LevelUpPanel.level_up_queue = level - level_before_collect
	$%LevelUpPanel.display_level_up_screen()

func get_xp_lvl_up_req() -> int:
	if level < 20: return level*5
	if level < 40: return 95 + (level-19)*8
	return 255 + (level-39)*12

func set_exp_bar(value, max_value):
	$%ExperienceBar.value = value * 100.0 / max_value

func upgrade(upgrade_object) -> void:
	pass
