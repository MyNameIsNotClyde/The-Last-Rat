extends Node2D

const WEAPON_LIST = { 
	# Key must be the same as weapon name
	"Shotgun": preload("res://scripts/weapons/shotgun.tscn"),
	"Crossbow": preload("res://scripts/weapons/crossbow.tscn"),
	"Knives": preload("res://scripts/weapons/knife_thrower.tscn"),
	"Poison Vials": preload("res://scripts/weapons/poison_vial_thrower.tscn")
}

const ITEM_LIST = [
	{
		"name": "Medical Cheese",
		"icon": preload("res://assets/sprites/upgrades/cheese.png"),
		"type": "item",
		"level": 0,
		"description": "Heals for 20 health.",
		"weight": 60
	}, {
		"name": "Magnifying Glass",
		"icon": preload("res://assets/sprites/upgrades/cheese.png"),
		"type": "item",
		"level": 0,
		"description": "Increases projectile size by 10% per stack.",
		"weight": 40
	}, {
		"name": "Iron Plating",
		"icon": preload("res://assets/sprites/upgrades/cheese.png"),
		"type": "item",
		"level": 0,
		"description": "Reduces incoming damage by 1 per stack, to a minimum of 1.",
		"weight": 60
	}, {
		"name": "Dusty Boots",
		"icon": preload("res://assets/sprites/upgrades/cheese.png"),
		"type": "item",
		"level": 0,
		"description": "Increases movement speed by 25% per stack.",
		"weight": 60
	}, {
		"name": "Ergonomic Grip",
		"icon": preload("res://assets/sprites/upgrades/cheese.png"),
		"type": "item",
		"level": 0,
		"description": "Decreases cooldown by 5% per stack.",
		"weight": 40
	}, {
		"name": "Silver alloy",
		"icon": preload("res://assets/sprites/upgrades/cheese.png"),
		"type": "item",
		"level": 0,
		"description": "Increases damage by 10% per stack.",
		"weight": 30
	}, {
		"name": "Compact Ammo",
		"icon": preload("res://assets/sprites/upgrades/cheese.png"),
		"type": "item",
		"level": 0,
		"description": "Increases projectile amount per volley by 1.",
		"weight": 20
	}, {
		"name": "Ribbon",
		"icon": preload("res://assets/sprites/upgrades/ribbon.png"),
		"type": "item",
		"level": 0,
		"description": "Does nothing. Looks cute on you though.",
		"weight": 0
	}
]

func apply_item_effects(player: CharacterBody2D, obj):
	match obj["name"]:
		"Medical Cheese":
			player.health = min(player.health + 20, player.max_health)
		"Magnifying Glass":
			player.area += 0.1
		"Iron Plating":
			player.armour += 1
		"Dusty Boots":
			player.speed += 20.0
		"Ergonomic Grip":
			player.cooldown -= 0.05
		"Silver Alloy":
			player.might += 0.1
		"Compact Ammo":
			player.multi += 1
		"Ribbon":
			pass
