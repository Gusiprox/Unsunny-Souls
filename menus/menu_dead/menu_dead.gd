extends Control


func _on_btn_reload_pressed():
	var escena_actual = get_tree().current_scene
	var ruta = Global.nivelActual
	get_tree().change_scene_to_file(ruta)


func _on_btn_exit_pressed() -> void:
	get_tree().quit()
