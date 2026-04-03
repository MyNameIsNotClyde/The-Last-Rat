extends CharacterBody2D

@export var speed = 20
@export var health = 20
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
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
	
	move_and_slide()


func _on_hurtbox_hurt(damage: Variant) -> void:
	health -= damage
	if health <= 0: queue_free()
