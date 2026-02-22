extends Control

@onready var panelNiveles = $panelNiveles
@onready var conNiveles = $panelNiveles/scrollNiveles/centerNiveles/conNiveles
@onready var btnRandom = $panelNiveles/btnRandom
@onready var btnReturn = $panelNiveles/btnReturn

var niveles = [
	{"ruta": "res://environment/levels/nivel_1.tscn", "nombre": "Bosque"}
]

func _ready():
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
		btn.pressed.connect(Callable(self, "_onNivelPressed").bind(niveles[i]["ruta"]))
		conNiveles.add_child(btn)


func _onNivelPressed(nivelPath: String):
	get_tree().change_scene_to_file(nivelPath)


func _on_btn_random_pressed() -> void:
	var nivelAleatorio = niveles[randi() % niveles.size()]["ruta"]
	get_tree().change_scene_to_file(nivelAleatorio)	


func _on_btn_return_pressed() -> void:
	panelNiveles.visible = false
