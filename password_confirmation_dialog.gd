extends Window

signal password_correct(password:String)
signal password_wrong()

func _ready():
	_update_ok_button()

func _update_ok_button():
	if (%LineEdit_password.text != ""): %Button_ok.disabled = false
	else: %Button_ok.disabled = true

func _on_line_edit_password_text_changed(new_text):
	_update_ok_button()

func _on_button_ok_pressed():
	if (%LineEdit_password.text.sha256_buffer() == Master.master_password_hash): password_correct.emit(%LineEdit_password.text)
	else: password_wrong.emit()
	close_requested.emit()

func _on_button_cancle_pressed():
	close_requested.emit()

func _on_close_requested():
	%LineEdit_password.clear()
	visible = false
