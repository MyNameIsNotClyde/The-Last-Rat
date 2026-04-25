extends Panel

var queue = 0
var selected_index = 0
@onready var upgrade_slot = preload("res://scripts/hud/upgrade_menu_slot.tscn")
@onready var player = get_tree().get_first_node_in_group("player")

func get_possible_upgrades() -> Array:
	var possible_upgrades = []
	for weapon_name in UpgradeDB.WEAPON_LIST:
		var weapon = player.weapon_manager.weapons[weapon_name]
		if weapon.level < len(weapon.UPGRADE_TABLE):
			var upgrade_info = weapon.UPGRADE_TABLE[weapon.level+1].duplicate()
			upgrade_info["name"] = weapon_name
			upgrade_info["icon"] = weapon.weapon_icon
			upgrade_info["type"] = "weapon"
			possible_upgrades.append(upgrade_info)
	return possible_upgrades

func display_level_up_screen() -> void:
	if queue < 1: return
	$LevelUpSound.play()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(220, 50), 0.2
		).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	selected_index = 0
	visible = true
	var slot_max = 3
	var possible_upgrades = get_possible_upgrades()
	possible_upgrades.shuffle()
	for slot_index in range(min(slot_max, len(possible_upgrades))):
		var new_upgrade_slot = upgrade_slot.instantiate()
		new_upgrade_slot.object = possible_upgrades[slot_index]
		new_upgrade_slot.connect("upgrade_selected", Callable(self, "upgrade_selected_handler"))
		$UpgradeMenu.add_child(new_upgrade_slot)
	queue -= 1
	get_tree().paused = true

func upgrade_selected_handler(upgrade_object) -> void:
	if upgrade_object["type"] == "weapon":
		player.weapon_manager.weapons[upgrade_object["name"]].upgrade_to(upgrade_object["level"])
	
	# Cleanup
	for slot in $UpgradeMenu.get_children():
		slot.queue_free()
	visible = false
	position = Vector2(800, 50)
	get_tree().paused = false
	call_deferred("display_level_up_screen")
