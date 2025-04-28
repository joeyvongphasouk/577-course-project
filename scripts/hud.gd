extends CanvasLayer

# refers to the player
@export var player: Node
@onready var item_slot_scene = preload("res://scenes/item_slot.tscn")
@onready var inventory_list: VBoxContainer = $MarginContainer/InventoryList
var current_item_slots: Array[Node]

func update_health() -> void:
	player.current_health / player.max_health * 100
	pass

func _ready() -> void:
	_update_inventory()
	player.update_hud.connect(_update_inventory)
	pass

func _update_inventory() -> void:
	# remove all previous items
	for item in current_item_slots:
		item.queue_free()
	current_item_slots.clear()
	
	# make new items
	var curr_inventory = player.get_inventory_list()
	for i in len(curr_inventory):
		if curr_inventory[i]:
			var slot = item_slot_scene.instantiate()
			var name: Label = slot.find_child("ItemName")
			var num: Label = slot.find_child("ItemNum")
			if i == 0:
				name.text = "Grapple Gun"
			else:
				name.text = "Key"
			num.text = str(i + 1)
			inventory_list.add_child(slot)
			current_item_slots.append(slot)
			print("updated inven:", i)
