extends Button

var object
signal upgrade_selected(upgrade_object)

func _on_pressed() -> void:
	emit_signal("upgrade_selected", object)
