extends CanvasLayer

@onready var experience_bar = $ExperienceBar
@onready var experience_bar_label = $ExperienceBar/LevelLabel
@onready var level_up_panel = $LevelUpPanel
@onready var timer_label = $TimerLabel
@onready var collected_weapons = $CollectedWeapons
@onready var collected_items = $CollectedItems

var time = 0.0

func _ready() -> void:
	set_experience_bar(0.0, 100.0)

func _process(delta: float) -> void:
	time += delta
	@warning_ignore("integer_division")
	timer_label.text = str(int(time) / 60).lpad(2,'0') + ':' + str(int(time) % 60).lpad(2,'0')

func set_experience_bar(value: float, max_value: float):
	experience_bar.value = value
	experience_bar.max_value = max_value

func set_gold_label_text(value: int):
	$GoldLabel.text = str(value)

func add_to_collection(upgrade_obj):
	var search_in = null
	if upgrade_obj.type == "weapon": search_in = collected_weapons
	elif upgrade_obj.type == "item": search_in = collected_items
	for collect in search_in.get_children():
		if collect.upgrade_name == upgrade_obj["name"]:
			collect.set_upgrade(upgrade_obj)
			return
	
	var new_item_container = preload("res://scripts/hud/item_container.tscn").instantiate()
	new_item_container.set_upgrade(upgrade_obj)
	search_in.add_child(new_item_container)

func move_result_panel(player_obj):
	var result_panel = $ResultPanel
	$ResultPanel/TitleLabel.text = "Game Over" if time < 300 else "You Win :D"
	@warning_ignore("integer_division")
	$ResultPanel/TimeLabel.text = "Time: " + str(int(time) / 60).lpad(2,'0') + ':' + str(int(time) % 60).lpad(2,'0')
	$ResultPanel/LevelLabel.text = "Level: " + str(player_obj.level)
	$ResultPanel/GoldLabel.text = "Gold: " + str(player_obj.gold)
	result_panel.position = Vector2(220, -400)
	result_panel.visible = true
	$ResultPanel/ToMenuButton.grab_focus()
	
	var tween = result_panel.create_tween()
	tween.tween_property(result_panel, "position", Vector2(220, 50), 3.0)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _on_to_menu_button_pressed() -> void:
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://scripts/menu.tscn")

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var tree = get_tree()
		if not tree.paused:
			tree.paused = true
			move_pause_panel()

func move_pause_panel():
	var pausePanel = $PausePanel
	pausePanel.position = Vector2(220, -400)
	pausePanel.visible = true
	var tween = pausePanel.create_tween()
	tween.tween_property(pausePanel, "position", Vector2(220, 50), 0.5)\
		.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	$PausePanel/TweenTimer.start()

func _on_resume_button_pressed() -> void:
	var pausePanel = $PausePanel
	pausePanel.position = Vector2(220, -400)
	pausePanel.visible = false
	get_tree().paused = false

func _on_tween_timer_timeout() -> void:
	$PausePanel/ResumeButton.grab_focus()
