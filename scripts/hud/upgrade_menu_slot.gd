extends Button

var object
signal upgrade_selected(upgrade_object)

func _ready() -> void:
	$LabelName.text = object["name"]
	$LabelDescription.text = object["description"]
	var level = object["level"]
	if level == 0:
		$LabelLevel.visible = false
	else:
		$LabelLevel.text = "Lv " + str(object["level"])
	$UpgradeIconBackground/UpgradeIcon.texture = object["icon"]

func _on_pressed() -> void:
	emit_signal("upgrade_selected", object)
