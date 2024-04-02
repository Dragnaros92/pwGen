extends VBoxContainer

func _ready():
	_on_relevant_text_changed("")

func _on_button_confirm_pressed():
	Master.user_name = %LineEdit_name.text
	Master.master_password_hash = %LineEdit_password.text.sha256_buffer()
	if (Master.file_load()):
		get_parent().add_child.call_deferred(load("res://password_list.tscn").instantiate())
		queue_free()
	else: 
		Master.clear()
		get_parent().add_child.call_deferred(load("res://file_pick.tscn").instantiate())
		queue_free()


func _on_button_cancel_pressed():
	get_parent().add_child.call_deferred(load("res://file_pick.tscn").instantiate())
	queue_free()


func _on_relevant_text_changed(new_text):
	if (%LineEdit_name.text.length() > 0 && %LineEdit_password.text.length() > 0):
		%Button_confirm.disabled = false
	else: 
		%Button_confirm.disabled = true
