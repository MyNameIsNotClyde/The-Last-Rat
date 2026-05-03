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
		"name": "Medical Treatment",
		"icon": preload("res://assets/sprites/upgrades/heart.png"),
		"type": "item",
		"description": "Heals for 30% of your max health.",
		"weight": 60
	}, {
		"name": "Magnifying Spyglass",
		"icon": preload("res://assets/sprites/upgrades/spyglass.png"),
		"type": "item",
		"description": "Increases projectile size by 10% per stack.",
		"weight": 40
	}, {
		"name": "Iron Plating",
		"icon": preload("res://assets/sprites/upgrades/armour.png"),
		"type": "item",
		"description": "Reduces incoming damage by 1 per stack, to a minimum of 1.",
		"weight": 60
	}, {
		"name": "Dusty Boots",
		"icon": preload("res://assets/sprites/upgrades/boots.png"),
		"type": "item",
		"description": "Increases movement speed by 20% per stack.",
		"weight": 60
	}, {
		"name": "Ergonomic Grip",
		"icon": preload("res://assets/sprites/upgrades/grip.png"),
		"type": "item",
		"description": "Decreases cooldown by 5% per stack.",
		"weight": 40
	}, {
		"name": "Silver Alloy",
		"icon": preload("res://assets/sprites/upgrades/silver.png"),
		"type": "item",
		"description": "Increases damage by 10% per stack.",
		"weight": 30
	}, {
		"name": "Compact Ammo",
		"icon": preload("res://assets/sprites/upgrades/ammo_box.png"),
		"type": "item",
		"description": "Increases projectile amount per volley by 1 per stack.",
		"weight": 20
	}, {
		"name": "Ribbon",
		"icon": preload("res://assets/sprites/upgrades/ribbon.png"),
		"type": "item",
		"description": "Does nothing. Looks cute on you though.",
		"weight": 0
	}
]

func apply_item_effects(player: CharacterBody2D, obj):
	match obj["name"]:
		"Medical Treatment":
			player.health = min(player.health + player.max_health*0.3, player.max_health)
		"Magnifying Spyglass":
			player.area += 0.1
		"Iron Plating":
			player.armour += 1
		"Dusty Boots":
			player.speed += 16.0
		"Ergonomic Grip":
			player.cooldown -= 0.05
		"Silver Alloy":
			player.might += 0.1
		"Compact Ammo":
			player.multi += 1
		"Ribbon":
			pass
