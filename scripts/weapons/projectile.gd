class_name Projectile extends Node2D

var durability: int # Piercing power
var speed: int # Travel speed, in pixels per second
var angle: Vector2 # Travel angle
var size: float # Size modifier
var despawn_time: float = 4.0

signal node_freed(obj)

func set_props(gpos,ang,spd,dur,dmg,kbp,siz):
	global_position = gpos
	angle = ang
	speed = spd
	durability = dur
	size = siz
	$Hitbox.damage = dmg
	$Hitbox.kb_power = kbp

func _ready() -> void:
	$Hitbox.kb_angle = angle
	$Sprite2D.rotation = angle.angle() + PI/2
	var despawnTimer = Timer.new()
	despawnTimer.name = "DespawnTimer"
	despawnTimer.wait_time = despawn_time
	despawnTimer.autostart = true
	despawnTimer.connect("timeout", despawn)
	add_child(despawnTimer)

func _physics_process(delta: float) -> void:
	position += angle * speed * delta

func enemy_hit(charge = 1):
	durability -= charge
	if durability <= 0:
		emit_signal("node_freed", self)
		queue_free()

func despawn():
	emit_signal("node_freed", self)
	queue_free()
