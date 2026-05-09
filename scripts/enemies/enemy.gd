class_name Enemy extends CharacterBody2D

@export var speed: float
@export var health: float
@export var kb_recovery: float
@export var damage: float
@export var loot_exp: int
@export var loot_gold: int
var kb_force = Vector2.ZERO
var is_dead = false
var free_if_off_screen = false

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_pool = get_tree().get_first_node_in_group("loot")
var loot_exp_obj = preload("res://scripts/objects/experience_loot.tscn")
var loot_gold_obj = preload("res://scripts/objects/gold_loot.tscn")

func _ready() -> void:
	$Hitbox.damage = damage

func _process(_delta: float) -> void:
	if not free_if_off_screen: return
	if $VisibleOnScreenNotifier2D.is_on_screen(): return
	queue_free()

func _physics_process(_delta: float) -> void:
	kb_force = kb_force.move_toward(Vector2.ZERO, kb_recovery)
	if player == null: return
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	if velocity.x > 0: $Sprite2D.flip_h = false
	if velocity.x < 0: $Sprite2D.flip_h = true
	if velocity.length() > 0:
		if $WalkTimer.is_stopped():
			$Sprite2D.frame = ($Sprite2D.frame + 1) % $Sprite2D.hframes
			$WalkTimer.start()
	else:
		$Sprite2D.frame = 0
	
	velocity += kb_force
	move_and_slide()

func _on_hurtbox_hurt(take_damage: float, kb_power: int, kb_angle: Vector2) -> void:
	health -= take_damage
	kb_force = kb_angle * kb_power
	if health <= 0: death()

func death():
	# The is_dead check is necessary since multiple hurtbox hurt can occur in a frame
	if is_dead: return
	is_dead = true
	var new_loot_exp = loot_exp_obj.instantiate()
	new_loot_exp.global_position = global_position
	new_loot_exp.experience_amount = loot_exp
	loot_pool.call_deferred("add_child", new_loot_exp)
	var new_loot_gold = loot_gold_obj.instantiate()
	var random_radius = 20 * sqrt(randf())
	var random_angle = 2*PI * randf()
	new_loot_gold.global_position = global_position + random_radius*Vector2.from_angle(random_angle)
	new_loot_gold.gold_amount = loot_gold
	loot_pool.call_deferred("add_child", new_loot_gold)
	var hurtbox = $Hurtbox
	hurtbox.emit_signal("node_freed", hurtbox)
	queue_free()
