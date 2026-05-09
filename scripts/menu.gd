extends Control

var level = "res://scripts/world.tscn"

func _ready() -> void:
	get_tree().paused = false

func _on_focus_timer_timeout() -> void:
	$PlayButton.grab_focus()

func _on_play_button_pressed() -> void:
	var _level = get_tree().change_scene_to_file(level)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
