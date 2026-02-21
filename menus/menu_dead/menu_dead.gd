extends Control


func _on_btn_reload_pressed():
	get_tree().change_scene_to_file("res://enviroment/environment.tscn")	


func _on_btn_exit_pressed() -> void:
	get_tree().quit()
