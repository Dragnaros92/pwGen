extends VBoxContainer


func _ready():
	_on_relevant_text_changed("")


func close():
	get_parent().add_child.call_deferred(load("res://password_list.tscn").instantiate())
	queue_free()


func set_password():
	var password:Password = Password.new(%LineEdit_adress.text, %LineEdit_name.text)
	password.blacklist = %LineEdit_blacklist.text
	password.length = %SpinBox_length.value
	password.iteration = %SpinBox_iteration.value
	Master.set_password(password)


func load_password(password:Password):
	%LineEdit_adress.text = password.adress
	%LineEdit_name.text = password.name
	%LineEdit_blacklist.text = password.blacklist
	%SpinBox_length.value = password.length
	%SpinBox_iteration.value = password.iteration


func _on_relevant_text_changed(new_text):
	if (%LineEdit_adress.text == "" || %LineEdit_name.text == ""):
		%Button_confirm.disabled = true
	else: %Button_confirm.disabled = false


func _on_button_confirm_pressed():
	if (Master.find_password(Password.new(%LineEdit_adress.text, %LineEdit_name.text)) != null):
		%ConfirmationDialog.visible = true
		return
	set_password()
	close()


func _on_button_cancel_pressed():
	close()


func _on_confirmation_dialog_confirmed():
	set_password()
	close()
