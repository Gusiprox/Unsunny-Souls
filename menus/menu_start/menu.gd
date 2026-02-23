extends Control

@onready var panelNiveles = $panelNiveles
@onready var conNiveles = $panelNiveles/scrollNiveles/centerNiveles/conNiveles
@onready var btnRandom = $panelNiveles/btnRandom
@onready var btnReturn = $panelNiveles/btnReturn
@export var btnFont: FontFile = preload("res://menus/menu_start/font/antiquity-print.ttf")


var niveles = [
	{"ruta": "res://environment/levels/nivel_1.tscn", "nombre": "Bosque"},
	{"ruta": "res://environment/levels/nivel_2.tscn", "nombre": "Cueva Boscosa"}
]

func _ready():
	randomize()
	panelNiveles.visible = false
	crearBotonesNiveles()


func _on_btn_start_pressed():
	panelNiveles.visible = true


func _on_btn_exit_pressed() -> void:
	get_tree().quit()


func crearBotonesNiveles():
	for i in range(niveles.size()):
		var btn = Button.new()
		btn.text = niveles[i]["nombre"]
		
		if btnFont:
			btn.add_theme_font_override("font", btnFont)
			btn.add_theme_font_size_override("font_size", 14)
			
		btn.pressed.connect(Callable(self, "_onNivelPressed").bind(niveles[i]["ruta"]))
		conNiveles.add_child(btn)


func _onNivelPressed(nivelPath: String):
	Global.nivelActual = nivelPath
	get_tree().change_scene_to_file(nivelPath)


func _on_btn_random_pressed() -> void:
	var index = randi_range(0, niveles.size() - 1)
	var nivelAleatorio = niveles[index]["ruta"]
	Global.nivelActual = nivelAleatorio
	get_tree().change_scene_to_file(nivelAleatorio)	


func _on_btn_return_pressed() -> void:
	panelNiveles.visible = false
