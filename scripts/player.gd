extends CharacterBody2D

var level = 1
var experience = 0
var gold = 0

var max_health: float = 100.0
var health: float = max_health
var regeneration: float = 0.0
var speed: float = 80
var might: float = 0.0 # Additional damage modifier
var dexterity: float = 0.0 # Additional projectile speed modifier
var area: float = 0.0 # Additional projectile size modifier
var cooldown: float = 0.0 # Additional fire rate modifier
var multi: int = 0 # Additional bullets fired / max ammo modifier

@onready var hud = get_tree().get_first_node_in_group('hud')
@onready var weapon_manager = $WeaponManager

func _ready() -> void:
	weapon_manager.detector = $EnemyDetector
	weapon_manager.weapons["Shotgun"].upgrade_to(1)

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
	health -= damage
	$HealthBar.value = health * 100.0 / max_health

func _on_loot_collector_exp_gain(amount: int) -> void:
	var experience_needed_to_level_up = get_xp_lvl_up_req()
	experience += amount
	while experience >= experience_needed_to_level_up:
		# Level up
		level += 1
		hud.leveled_up()
		hud.experience_bar_label.text = str("Level ",level)
		experience -= experience_needed_to_level_up
		experience_needed_to_level_up = get_xp_lvl_up_req()
	hud.set_experience_bar(experience, experience_needed_to_level_up)
	hud.level_up_panel.display_level_up_screen()

func _on_loot_collector_gold_gain(amount: int) -> void:
	gold += amount

func get_xp_lvl_up_req() -> int:
	if level < 20: return level*5
	if level < 40: return 95 + (level-19)*8
	return 255 + (level-39)*12
