extends Projectile

var duration: float
var damage_interval: float
var target_position: Vector2

func _ready() -> void:
	$SpriteVial.visible = true
	$SpritePool.visible = false
	$TimerDuration.wait_time = duration
	$Hitbox.cooldown_length = damage_interval
	$SpriteVial.rotation = PI/4 if global_position.x >= target_position.x else -PI/4
	var target_rotation = -9*PI/4 if global_position.x >= target_position.x else 9*PI/4
	var travel_time = 80.0 / speed
	var gravity = 500.0/travel_time/travel_time
	var initial_velocity_y = (target_position.y - global_position.y - gravity*travel_time*travel_time/2)/travel_time
	var lerp_position_y = func(t, init_vel_y, init_pos_y):
		global_position.y = init_pos_y + init_vel_y*t + gravity*t*t/2
	var tween = create_tween()
	tween.tween_property(self, "global_position:x", target_position.x, travel_time)
	tween.parallel().tween_method(lerp_position_y.bind(global_position.y).bind(initial_velocity_y), 0.0, travel_time, travel_time)
	tween.parallel().tween_property($SpriteVial, "rotation", target_rotation, travel_time)
	$TimerTravel.start(travel_time)

func _physics_process(_delta: float) -> void:
	pass

func enemy_hit(_charge = 1):
	pass

func _on_timer_travel_timeout() -> void:
	$SoundSplash.play()
	$TimerDuration.start()
	$SpriteVial.visible = false
	$SpritePool.visible = true
	$Hitbox/CollisionShape2D.set_deferred("disabled", false)

func _on_timer_duration_timeout() -> void:
	$TimerFade.start()
	var tween = create_tween()
	tween.tween_property($SpritePool, "self_modulate", Color.TRANSPARENT, 0.5)
