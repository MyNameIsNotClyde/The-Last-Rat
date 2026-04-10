extends Panel

var level_up_queue = 0
var selected_index = 0
@onready var upgrade_slot = preload("res://scripts/hud/upgrade_menu_slot.tscn")

signal upgrade_selected(upgrade_object)

func display_level_up_screen() -> void:
	if level_up_queue < 1: return
	$LevelUpSound.play()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(220, 50), 0.2
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	selected_index = 0
	visible = true
	var slot_max = 3
	for slot_index in range(slot_max):
		var new_upgrade_slot = upgrade_slot.instantiate()
		new_upgrade_slot.connect("upgrade_selected", Callable(self, "upgrade_selected_handler"))
		$UpgradeMenu.add_child(new_upgrade_slot)
	level_up_queue -= 1
	get_tree().paused = true

func upgrade_selected_handler(upgrade_object) -> void:
	for slot in $UpgradeMenu.get_children():
		slot.queue_free()
	visible = false
	position = Vector2(800, 50)
	get_tree().paused = false
	emit_signal("upgrade_selected", upgrade_object)
	display_level_up_screen()
