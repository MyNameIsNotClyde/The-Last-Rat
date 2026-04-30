extends Panel

var upgrade_name: String
var icon: Resource
var level: int
func set_upgrade(upgrade_obj) -> void:
	upgrade_name = upgrade_obj["name"]
	$ItemTexture.texture = upgrade_obj["icon"]
	level = upgrade_obj["level"]
	$LevelLabel.text = str(level) if level > 0 else ""
