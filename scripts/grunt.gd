extends CharacterBody2D

@export var speed = 20
@export var health = 20
@export var kb_recovery = 4
var kb_force = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

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
	if health <= 0:
		emit_signal("node_freed", self)
		queue_free()
