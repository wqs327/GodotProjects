extends Control

var grid_button_scene = preload("res://scenes/grid_button.tscn")
var list_button_scene = preload("res://scenes/list_button.tscn")
const main_buttons = {
	Global.State.ATTACK: '攻击',
	Global.State.DEFEND: '防御',
	Global.State.SWAP: '切换',
	Global.State.ITEM: '道具',
	}
var current_state: Global.State: set = state_handler
signal selected(state: Global.State, type)


func _ready() -> void:
	current_state = Global.State.MAIN


func  _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		current_state = Global.State.MAIN


func create_grid_buttons(state:Global.State, data:Dictionary):
	for i in $GridContainer.get_children():
		i.queue_free()
	for key in data:
		var grid_buttton = grid_button_scene.instantiate()
		grid_buttton.setup(state,key,data[key])
		$GridContainer.add_child(grid_buttton)
		grid_buttton.connect('press', button_handler)
	await get_tree().process_frame
	$GridContainer.get_child(0).grab_focus()


func create_list_buttons(state:Global.State, data:Array):
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for key in data:
		var list_button = list_button_scene.instantiate()
		$ScrollContainer/VBoxContainer.add_child(list_button)
		list_button.setup(state, key)
		list_button.connect('press', button_handler)
	await get_tree().process_frame
	$ScrollContainer/VBoxContainer.get_child(0).grab_focus()


func button_handler(state, type):
	if state == Global.State.MAIN:
		current_state = type
		if type == Global.State.DEFEND:
			selected.emit(Global.State.DEFEND,type)
	else:
		selected.emit(state,type)	


func state_handler(value):
	current_state = value
	
	match value: 
		Global.State.ATTACK:
			$GridContainer.show()
			$ScrollContainer.hide()
			var monster_attacks = Global.monster_data[Global.current_monster]['attacks']	
			create_grid_buttons(Global.State.ATTACK, {
			monster_attacks[0]: Global.attack_data[monster_attacks[0]]['name'],
			monster_attacks[1]: Global.attack_data[monster_attacks[1]]['name'],
			monster_attacks[2]: Global.attack_data[monster_attacks[2]]['name'],
			monster_attacks[3]: Global.attack_data[monster_attacks[3]]['name'],
			})
			
		Global.State.MAIN:
			$GridContainer.show()
			$ScrollContainer.hide()
			create_grid_buttons(Global.State.MAIN,main_buttons)
		
		Global.State.SWAP:
			$GridContainer.hide()
			$ScrollContainer.show()
			create_list_buttons(Global.State.SWAP,Global.monsters)
			
		Global.State.ITEM:
			$GridContainer.hide()
			$ScrollContainer.show()
			create_list_buttons(Global.State.ITEM,Global.items)


func _on_visibility_changed() -> void:
	current_state = Global.State.MAIN
