extends CharacterBody2D

var level = 1
var experience = 0
var gold = 0

var max_health: float = 50.0
var health: float = max_health
var regeneration: float = 0.0
var armour: int = 0
var speed: float = 80.0
var might: float = 1.0 # Damage modifier
var dexterity: float = 1.0 # Projectile speed modifier
var area: float = 1.0 # Projectile size modifier
var cooldown: float = 1.0 # Fire interval modifier
var multi: int = 0 # Projectile amount modifier

@onready var hud = get_tree().get_first_node_in_group('hud')
@onready var weapon_manager = $WeaponManager
@onready var starting_weapon = weapon_manager.weapons["Shotgun"]

signal player_death
signal player_death_animation_complete

func _ready() -> void:
	weapon_manager.detector = $EnemyDetector
	starting_weapon.upgrade_to(1)
	await hud.ready
	connect("player_death_animation_complete", hud.move_result_panel.bind(self))
	hud.add_to_collection({
		"name": starting_weapon.weapon_name,
		"icon": starting_weapon.weapon_icon,
		"level": 1,
		"type": "weapon"
		})

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
	$WeaponManager.attack()

func _on_hurtbox_hurt(damage: int, _kb_power, _kb_angle) -> void:
	health -= max(damage - armour, 1.0)
	set_health_bar()
	if health <= 0:
		emit_signal("player_death")
		get_tree().paused = true
		start_death_animation()

func set_health_bar():
	$HealthBar.value = health
	$HealthBar.max_value = max_health

func _on_loot_collector_exp_gain(amount: int) -> void:
	var experience_needed_to_level_up = get_xp_lvl_up_req()
	experience += amount
	while experience >= experience_needed_to_level_up:
		# Level up
		level += 1
		max_health += 5
		health += 5
		set_health_bar()
		hud.level_up_panel.queue += 1
		hud.experience_bar_label.text = str("Level ",level)
		experience -= experience_needed_to_level_up
		experience_needed_to_level_up = get_xp_lvl_up_req()
	hud.set_experience_bar(experience, experience_needed_to_level_up)
	hud.level_up_panel.display_level_up_screen()

func _on_loot_collector_gold_gain(amount: int) -> void:
	gold += amount
	hud.set_gold_label_text(gold)

func get_xp_lvl_up_req() -> int:
	if level < 20: return level*5
	if level < 40: return 95 + (level-19)*8
	return 255 + (level-39)*12

func start_death_animation() -> void:
	$HealthBar.visible = false
	$ExplosionSprite2D.visible = true
	$ExplosionSprite2D.frame = 0
	$ExplosionSprite2D/FrameTimer.start()
	$ExplosionSprite2D/ExplosionSound.play()

func continue_death_animation() -> void:
	var explosion_sprite = $ExplosionSprite2D
	if explosion_sprite.frame == 17:
		emit_signal("player_death_animation_complete")
		explosion_sprite.visible = false
		return
	if explosion_sprite.frame == 4:
		$Sprite2D.visible = false
	explosion_sprite.frame += 1
	$ExplosionSprite2D/FrameTimer.start()
