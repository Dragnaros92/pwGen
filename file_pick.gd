extends VBoxContainer


func _ready():
	if (Master.file_path.length() <= 0): 
		%Button_open_last.disabled = true
	else: 
		%Button_open_last.disabled = false


func _on_button_open_pressed():
	%FileDialog_load.visible = true


func _on_button_new_pressed():
	%FileDialog_save.visible = true


func _on_file_dialog_load_file_selected(path):
	if (!path.ends_with(".pwgs")): return
	Master.file_path = path
	get_parent().add_child.call_deferred(load("res://file_load.tscn").instantiate())
	queue_free()


func _on_file_dialog_save_file_selected(path):
	if (!path.ends_with(".pwgs")): return
	Master.file_path = path
	get_parent().add_child.call_deferred(load("res://file_save.tscn").instantiate())
	queue_free()


func _on_button_open_last_pressed():
	get_parent().add_child.call_deferred(load("res://file_load.tscn").instantiate())
	queue_free()
