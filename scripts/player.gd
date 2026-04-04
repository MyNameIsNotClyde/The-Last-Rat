extends CharacterBody2D

@export var speed = 100
@export var max_health = 100
var health = 80
var weapons = []

func _ready() -> void:
	var shotgun = load("res://scripts/weapons/shotgun.tscn").instantiate()
	add_child(shotgun)
	weapons.append(shotgun)

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
		if weapon.ammo <= 0: continue
		match weapon.target_mode:
			0: # none
				weapon.shoot()
			1: # random
				weapon.shoot($EnemyDetector.get_random_enemy())
			2: # closest
				weapon.shoot($EnemyDetector.get_closest_enemy())

func _on_hurtbox_hurt(damage: int) -> void:
	health -= damage
	print(health)
