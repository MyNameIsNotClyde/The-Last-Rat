extends CharacterBody2D

@export var speed = 20
@export var health = 20
@export var kb_recovery = 4
@export var experience = 1
var kb_force = Vector2.ZERO
var is_dead = false

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_pool = get_tree().get_first_node_in_group("loot")
var exp_loot = preload("res://scripts/objects/experience_loot.tscn")

signal node_freed(obj)

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

func _on_hurtbox_hurt(damage: int, kb_power: int, kb_angle: Vector2) -> void:
	health -= damage
	kb_force = kb_angle * kb_power
	if health <= 0: death()

func death():
	# The is_dead check is necessary since multiple hurtbox hurt can occur in a fram
	if is_dead: return
	is_dead = true
	var new_exp_loot = exp_loot.instantiate()
	new_exp_loot.global_position = global_position
	new_exp_loot.experience_amount = experience
	loot_pool.call_deferred("add_child", new_exp_loot)
	emit_signal("node_freed", self)
	queue_free()
