extends CanvasLayer

@onready var experience_bar = $ExperienceBar
@onready var experience_bar_label = $ExperienceBar/LevelLabel
@onready var level_up_panel = $LevelUpPanel

func _ready() -> void:
	set_experience_bar(0.0, 100.0)

func set_experience_bar(value: float, max_value: float):
	experience_bar.value = value
	experience_bar.max_value = max_value

func leveled_up() -> void:
	level_up_panel.queue += 1
