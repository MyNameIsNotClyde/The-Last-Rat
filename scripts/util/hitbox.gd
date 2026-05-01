class_name Hitbox extends Area2D

enum HITBOX_TYPE { HIT_ONCE, COOLDOWN, COOLDOWN_EACH }
## hit once: only ever hit the same hurtbox once
## cooldown: hit the hurtbox everytime cooldown ends
## cooldown each: similar to cooldown but independent for each hurtbox

@export var hitbox_type: HITBOX_TYPE = HITBOX_TYPE.HIT_ONCE
var damage: float = 1.0
var kb_power: float = 100.0 # Knockback power
var kb_angle: Vector2 = Vector2.ZERO # Knockback angle
@export var cooldown_length: float = 0.5 # Ignored in hitbox type "hit once"

var _hit_once_list = []
var _cooldown_each_list = []

signal enemy_hit(toughness)

class HurtboxCooldown extends Timer:
	var hurtbox: Area2D
	signal timeout_custom(hbox)
	func _init(hbox: Area2D) -> void:
		hurtbox = hbox
		connect("timeout", Callable(self, "cooldown_timeout"))
	func cooldown_timeout():
		emit_signal("timeout_custom", self)

func _ready() -> void:
	if hitbox_type == HITBOX_TYPE.COOLDOWN:
		var cooldown_timer = Timer.new()
		cooldown_timer.name = "TimerCooldown"
		cooldown_timer.wait_time = cooldown_length
		cooldown_timer.one_shot = true
		var set_hitbox_to_active = func(): $CollisionShape2D.set_deferred("disabled", false)
		cooldown_timer.connect("timeout", set_hitbox_to_active)
		add_child(cooldown_timer)

func _on_area_entered(area: Area2D) -> void:
	if not area.has_signal("hurt"): return
	match hitbox_type:
		HITBOX_TYPE.HIT_ONCE:
			if _hit_once_list.has(area): return
			_hit_once_list.append(area)
			if not area.has_signal("node_freed"):
				print('Warning: Object %s has no node_freed signal.'%area.name)
				return
			if area.is_connected("node_freed", remove_from_hit_once_list): return
			area.connect("node_freed", remove_from_hit_once_list)
		HITBOX_TYPE.COOLDOWN:
			# No need to check if TimerCooldown is ongoing, since CollisionShape is disabled anyways
			$CollisionShape2D.set_deferred("disabled", true)
			$TimerCooldown.start()
		HITBOX_TYPE.COOLDOWN_EACH:
			if exists_in_cooldown_each_list(area): return
			var new_hurtbox_timer = HurtboxCooldown.new(area)
			new_hurtbox_timer.wait_time = cooldown_length
			new_hurtbox_timer.one_shot = true
			new_hurtbox_timer.connect("timeout_custom", reset_or_remove_from_cooldown_each_list)
			add_child(new_hurtbox_timer)
			_cooldown_each_list.append(new_hurtbox_timer)
			new_hurtbox_timer.start()
	area.emit_signal("hurt", damage, kb_power, kb_angle)
	emit_signal("enemy_hit",area.toughness if area.get("toughness") != null else 1)

func remove_from_hit_once_list(hurtbox_instance):
	if not _hit_once_list.has(hurtbox_instance): return
	_hit_once_list.erase(hurtbox_instance)

func reset_or_remove_from_cooldown_each_list(hurtbox_cooldown_instance: HurtboxCooldown):
	if not _cooldown_each_list.has(hurtbox_cooldown_instance): return
	var hurtbox = hurtbox_cooldown_instance.hurtbox
	if is_instance_valid(hurtbox) and self.overlaps_area(hurtbox):
		hurtbox.emit_signal("hurt", damage, kb_power, kb_angle)
		hurtbox_cooldown_instance.start()
	else:
		_cooldown_each_list.erase(hurtbox_cooldown_instance)
		hurtbox_cooldown_instance.queue_free()

func exists_in_cooldown_each_list(hurtbox):
	# Inefficient, maybe can be remade into a dict somehow
	# Will do for now though
	for hurtboxCooldown in _cooldown_each_list:
		if hurtboxCooldown.hurtbox == hurtbox: return true
	return false
