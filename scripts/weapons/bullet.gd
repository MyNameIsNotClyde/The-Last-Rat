extends Area2D

var durability = 1 # Projectile pierce
var speed = 100 # Projectile speed
var damage = 5 # Damage to enemies
var knockback = 100 # Knockback to enemies, unimplemented rn
var size = 1.0 # Projectile size
var angle = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta: float) -> void:
	position += angle*speed*delta

func enemy_hit(charge = 1):
	durability -= charge
	if durability <= 0: queue_free()

func _on_despawn_timer_timeout() -> void:
	queue_free()
