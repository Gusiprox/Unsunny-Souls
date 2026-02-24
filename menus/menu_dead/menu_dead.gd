extends Control

@onready var lblPoints = $conMenuDead/lblPoints

func _ready():
	Global._loadGame()
	lblPoints.text = "Puntos: " + str(Global.gameData.get(Global.nivelActual, 0))

func _on_btn_reload_pressed():
	var ruta = Global.nivelActual
	get_tree().change_scene_to_file(ruta)


func _on_btn_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menus/menu_start/menu.tscn")


func _on_btn_exit_pressed() -> void:
	get_tree().quit()
