class_name Password


var adress:String
var name:String
var blacklist:String = ""
var length:int = 32
var iteration:int = 0


func _init(_adress:String, _name:String):
	adress = _adress
	name = _name

func get_display_name():
	return adress + " [" + name + "]"

func to_bytearray():
	var arr:Array
	arr.append(adress)
	arr.append(name)
	arr.append(blacklist)
	arr.append(length)
	arr.append(iteration)
	return var_to_bytes(arr)

static func from_bytearray(byte_array:PackedByteArray):
	var arr:Array = bytes_to_var(byte_array)
	var pw:Password = Password.new(arr[0], arr[1])
	pw.blacklist = arr[2]
	pw.length = arr[3]
	pw.iteration = arr[4]
	return pw

func _get_valid_characters():
	var all_chars:String = (
		"0123456789" +
		"abcdefghijklmnopqrstuvwxyz" +
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
		"!\"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~")
	
	for char:String in blacklist:
		all_chars = all_chars.replace(char, "")
	
	return all_chars

func _hash_to_string(_hash:Array):
	var charlist:String = _get_valid_characters()
	var result:String = ""
	
	for byte:int in _hash:
		while (byte >= charlist.length()):
			byte -= charlist.length()
		result += charlist[byte]
	
	return result

func _get_hash_of_length(_key:String, _length:int):
	var hash:PackedByteArray = _key.sha256_buffer()
	if (hash.size() >= _length): return hash
	var hc:HashingContext = HashingContext.new()
	
	while (true):
		hc.start(HashingContext.HASH_SHA256)
		hc.update(hash)
		hash.append_array(hc.finish())
		if (hash.size() >= _length): break
	
	hash.resize(_length)
	return hash

func get_password(_master_password:String):
	var salt:String = adress + name + str(iteration)
	return _hash_to_string(
		_get_hash_of_length(_master_password + salt, length))

func password_to_clipboard(_master_password:String):
	DisplayServer.clipboard_set(get_password(_master_password))
