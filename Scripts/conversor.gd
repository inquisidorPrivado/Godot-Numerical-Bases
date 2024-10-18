extends CenterContainer
@onready var user_number : String = ""
@onready var user_from_base : int = -1
@onready var user_to_base : int = -1
@onready var show_result = $PanelContainer/VBoxContainer/Result
@onready var label_text_your_number : String

#func _ready():
	#var number = "286BC"  # Número en decimal
	#var from_base = 16
	#var to_base = 10
	#
#
	#var converted_number = convert_user_number(number, from_base, to_base)
	#
	#
	#print("El número ", number, " en base ", from_base, " es ", converted_number, " en base ", to_base, ".")





func select_base(option) -> int:
	match option:
		0:
			return 10
		1:
			return 2
		2:
			return 8
		3:
			return 16
	return -1


func _on_from_number_base_item_selected(index):
	var label_from : Label = $PanelContainer/VBoxContainer/IntroduceNumber
	var from_number_base_text : OptionButton =  $PanelContainer/VBoxContainer/OptionMenu/FromNumberBase
	
	
	label_from.text = "Ingrese su número en " + from_number_base_text.get_item_text(index).to_lower()
	
	#print(from_number_base_text.get_item_id(index))
	user_from_base = select_base(from_number_base_text.get_item_id(index))
	



func _on_to_number_base_item_selected(index):
	#var label_to : Label = $PanelContainer/VBoxContainer/OptionMenu/To
	var to_number_base_text : OptionButton = $PanelContainer/VBoxContainer/OptionMenu/ToNumberBase
	
	
	label_text_your_number = "Este es su número en " + to_number_base_text.get_item_text(index).to_lower()
	#print(to_number_base_text.get_item_id(index))
	user_to_base = select_base(to_number_base_text.get_item_id(index))
	
func _on_your_input_text_submitted(new_text):
	var label_to : Label = $PanelContainer/VBoxContainer/YourNumber
	var line_result : LineEdit = $PanelContainer/VBoxContainer/Result
	line_result.clear()
	
	if user_from_base != -1 and user_to_base != -1:
		#print(new_text)
		#print(user_from_base)
		#print(user_to_base)
		var converted_number = convert_user_number(new_text, user_from_base, user_to_base)
		
		label_to.text = label_text_your_number
		show_result.insert_text_at_caret(converted_number)
	else:
		label_to.text = "Faltan opciones a elegir"


func convert_user_number(number: String, from_base: int, to_base: int, precision: int = 10) -> String:
	# Convierte un número de una base a otra, manejando números fraccionarios.
	var decimal_number = base_to_decimal(number, from_base)
	print("AAAHHHEste es el resultado de base_to_decimal ", decimal_number)
	# Comprobar si es un string
	if decimal_number == null:
		return decimal_number
	return decimal_to_base(decimal_number, to_base, precision)


func decimal_to_base(number: float, base: int, precision: int = 10) -> String:
	# Convierte un número decimal (incluyendo fraccionarios) a cualquier base.
	if base < 2 or base > 36:
		return "La base debe estar entre 2 y 36."
	
	if number == 0:
		return "0"
	
	var digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	
	var integer_part = int(number)
	var fractional_part = number - integer_part

	# Convertir la parte entera
	var result = ""
	while integer_part != 0:
		result = digits[integer_part % base] + result
		integer_part = int(integer_part / base)  # Utiliza la división entera y convierte a entero

	# Convertir la parte fraccionaria
	if fractional_part > 0:
		result += "."
		while fractional_part > 0 and precision > 0:
			fractional_part *= base
			var digit = int(fractional_part)
			result += digits[digit]
			fractional_part -= digit
			precision -= 1
	
	return result



func base_to_decimal(number: String, base: int) -> float:
	# Mapeo de caracteres a valores numéricos
	var digit_map = {
		"0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
		"A": 10, "B": 11, "C": 12, "D": 13, "E": 14, "F": 15,
		"G": 16, "H": 17, "I": 18, "J": 19, "K": 20, "L": 21, "M": 22, "N": 23, "O": 24, "P": 25,
		"Q": 26, "R": 27, "S": 28, "T": 29, "U": 30, "V": 31, "W": 32, "X": 33, "Y": 34, "Z": 35
	}
	var integer_part: String = ""
	var fractional_part: String = ""

	# Separar la parte entera de la parte fraccionaria
	if number.find(".") != -1:
		var parts = number.split(".")
		integer_part = parts[0].to_upper()
		fractional_part = parts[1].to_upper()
	else:
		integer_part = number.to_upper()

	# Convertir la parte entera
	var integer_value = 0
	for i in range(integer_part.length()):
		var char = integer_part[i]
		var digit_value = digit_map.get(char, -1)
		
		if digit_value == -1:
			print("Carácter inválido encontrado:", char)
			return -1.0  # Indicar un error en la conversión
		
		integer_value = integer_value * base + digit_value
	
	# Convertir la parte fraccionaria
	var fractional_value = 0.0
	for i in range(fractional_part.length()):
		var char = fractional_part[i]
		var digit_value = digit_map.get(char, -1)
		
		if digit_value == -1:
			print("Carácter inválido encontrado:", char)
			return -1.0  # Indicar un error en la conversión
		
		fractional_value += digit_value * pow(base, -(i + 1))
	
	return integer_value + fractional_value






func _on_your_input_text_changed(new_text):
	var line_result : LineEdit = $PanelContainer/VBoxContainer/Result
	line_result.clear()
