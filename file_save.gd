extends VBoxContainer


func _ready():
	_update()

func _update():
	var name:LineEdit = %LineEdit_name
	var pw1:LineEdit = %LineEdit_password
	var pw2:LineEdit = %LineEdit_password2
	
	if (pw1.text != pw2.text):
		pw2.add_theme_color_override("font_color", Color.RED)
	else:
		pw2.add_theme_color_override("font_color", Color(0.875, 0.875, 0.875, 1))
	
	%Button_confirm.disabled = (pw1.text != pw2.text || pw1.text == "" || name.text == "")


func _on_button_confirm_pressed():
	Master.master_password_hash = %LineEdit_password.text.sha256_buffer()
	Master.user_name = %LineEdit_name.text
	get_parent().add_child.call_deferred(load("res://password_list.tscn").instantiate())
	queue_free()


func _on_button_cancel_pressed():
	get_parent().add_child.call_deferred(load("res://file_pick.tscn").instantiate())
	queue_free()


func _on_relevant_text_changed(new_text):
	_update()
