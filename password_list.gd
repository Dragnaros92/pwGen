extends VBoxContainer

func _ready():
	update_list()
	update_buttons()

func update():
	update_list()
	update_buttons()

func update_list():
	var list:ItemList = %ItemList
	list.clear()
	var filter:String = %LineEdit_search.text
	var name:String
	for p:Password in Master.passwords:
		name = p.get_display_name()
		if (name.begins_with(filter)): 
			list.add_item(name, null, true)
	list.sort_items_by_text()

func update_buttons():
	var b:bool = !%ItemList.is_anything_selected()
	%Button_copy.disabled = b
	%Button_edit.disabled = b
	%Button_remove.disabled = b

func remove_selected():
	var list:ItemList = %ItemList
	for i:int in list.get_selected_items():
		Master.remove_password_by_displayname(list.get_item_text(i))
	update()

func _on_button_add_pressed():
	get_parent().add_child.call_deferred(load("res://set_password.tscn").instantiate())
	queue_free()

func _on_line_edit_search_text_changed(new_text):
	update()

func _on_item_list_item_selected(index):
	update_buttons()

func _on_button_remove_pressed():
	%ConfirmationDialog_remove.visible = true

func _on_button_edit_pressed():
	var instant = load("res://set_password.tscn").instantiate()
	
	instant.load_password(
		Master.find_password_by_displayname(
			%ItemList.get_item_text(
				%ItemList.get_selected_items()[0])))
	
	get_parent().add_child.call_deferred(instant)
	queue_free()

func _on_button_copy_pressed():
	%PasswordConfirmationDialog.visible = true

func _on_password_confirmation_dialog_password_wrong():
	_on_button_exit_pressed()

func _on_password_confirmation_dialog_password_correct(password):
	var pw:Password = Master.find_password_by_displayname(%ItemList.get_item_text(%ItemList.get_selected_items()[0]))
	if (pw != null): pw.password_to_clipboard(password)

func _on_button_exit_pressed():
	Master.clear()
	get_parent().add_child.call_deferred(load("res://file_pick.tscn").instantiate())
	queue_free()
