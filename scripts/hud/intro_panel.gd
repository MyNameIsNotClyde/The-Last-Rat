extends Panel

func _ready() -> void:
	get_tree().paused = true

func _on_focus_timer_timeout() -> void:
	$ResumeButton.grab_focus()

func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
