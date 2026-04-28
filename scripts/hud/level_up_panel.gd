extends Panel

var queue = 0
var selected_index = 0
@onready var upgrade_slot = preload("res://scripts/hud/upgrade_menu_slot.tscn")
@onready var player = get_tree().get_first_node_in_group("player")

'''
Upgrade object interface:
	name - name of upgrade
	icon - path to upgrade icon
	level - 0 if the level label should not be displayed
	description - description text
'''

func get_random_upgrades(amount: int) -> Array:
	var upgrades
	var weapon_pool = []
	for weapon_name in UpgradeDB.WEAPON_LIST:
		var weapon = player.weapon_manager.weapons[weapon_name]
		if weapon.level < len(weapon.UPGRADE_TABLE):
			var upgrade_info = weapon.UPGRADE_TABLE[weapon.level].duplicate()
			upgrade_info["name"] = weapon_name
			upgrade_info["icon"] = weapon.weapon_icon
			upgrade_info["type"] = "weapon"
			weapon_pool.append(upgrade_info)
	weapon_pool.shuffle()
	upgrades = weapon_pool.slice(0, amount - randi_range(0, 1))
	if len(upgrades) == amount: return upgrades
	var rng = RandomNumberGenerator.new()
	var item_weights = []
	for item in UpgradeDB.ITEM_LIST:
		item_weights.append(item["weight"])
	for i in range(amount-len(upgrades)):
		upgrades.append(UpgradeDB.ITEM_LIST[rng.rand_weighted(item_weights)])
	if len(upgrades) < 3:
		upgrades.append(UpgradeDB.ITEM_LIST[-1])
	return upgrades

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
	var upgrades = get_random_upgrades(slot_max)
	for slot_index in range(len(upgrades)):
		var new_upgrade_slot = upgrade_slot.instantiate()
		new_upgrade_slot.object = upgrades[slot_index]
		new_upgrade_slot.connect("upgrade_selected", Callable(self, "upgrade_selected_handler"))
		$UpgradeMenu.add_child(new_upgrade_slot)
	queue -= 1
	get_tree().paused = true

func upgrade_selected_handler(upgrade_object) -> void:
	if upgrade_object["type"] == "weapon":
		var weapon = player.weapon_manager.weapons[upgrade_object["name"]]
		weapon.upgrade_to(upgrade_object["level"])
		weapon.update_stats(player)
	elif upgrade_object["type"] == "item":
		UpgradeDB.apply_item_effects(player, upgrade_object)
		for weapon in player.weapon_manager.weapons.values():
			weapon.update_stats(player)
		player.set_health_bar()
	# Cleanup
	for slot in $UpgradeMenu.get_children():
		slot.queue_free()
	visible = false
	position = Vector2(800, 50)
	get_tree().paused = false
	call_deferred("display_level_up_screen")
