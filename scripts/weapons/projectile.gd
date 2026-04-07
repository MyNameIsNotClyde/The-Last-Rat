@abstract class_name Projectile extends Node2D

var durability: int # Piercing power
var speed: int # Travel speed, in pixels per second
var angle: Vector2 # Travel angle
var damage: int # Damage dealt to hurtboxes
var kb_power: float # Knockback power
var size: float # Size modifier

signal node_freed(obj)

func _physics_process(delta: float) -> void:
	position += angle * speed * delta

func enemy_hit(charge = 1):
	durability -= charge
	if durability <= 0:
		emit_signal("node_freed", self)
		queue_free()
