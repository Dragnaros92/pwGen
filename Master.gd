extends Node

var master_password_hash:PackedByteArray
var user_name:String
var file_path:String

var passwords:Array[Password]


func remove_password(password:Password):
	passwords.erase(password)
	file_save()


func remove_password_by_displayname(displayname:String):
	var password = find_password_by_displayname(displayname)
	if (password != null): remove_password(password)


func set_password(password:Password):
	var old = find_password(password)
	if (old != null): passwords.erase(old)
	passwords.append(password)
	file_save()


func find_password(password:Password):
	var displayname = password.get_display_name()
	for p:Password in passwords:
		if (p.get_display_name() == displayname): return p
	return null


func find_password_by_displayname(displayname:String):
	for p:Password in passwords:
		if (p.get_display_name() == displayname): return p
	return null


func file_save():
	if (file_path.length() <= 0): 
		crash("Error", "Filepath is empty")
		return
	
	var pws:Array
	for pw in passwords:
		pws.append(pw.to_bytearray())
	var bin = var_to_bytes(pws)
	
	var file:FileAccess = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, _get_file_password())
	file.store_buffer(bin)
	file.close()

func file_load():
	if (file_path.length() <= 0): 
		crash("Error", "Filepath is empty")
		return
	
	var file:FileAccess = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, _get_file_password())
	if (file == null): return false
	var pws:Array = bytes_to_var(file.get_buffer(file.get_length()))
	file.close()
	
	passwords.clear()
	for pw in pws:
		passwords.append(Password.from_bytearray(pw))
	
	return true

func _get_file_password():
	return user_name + master_password_hash.hex_encode()


func crash(title, message):
	OS.alert(message,title)
	get_tree().quit()

func clear():
	master_password_hash.clear()
	user_name = ""
	passwords.clear()

