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
