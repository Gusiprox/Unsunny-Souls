extends Node


var nivelActual = ""

var savePath = "user://save.dat"

var gameData: Dictionary = {
	"res://environment/levels/nivel_1.tscn" : 0,
	"res://environment/levels/nivel_2.tscn" : 0
}


func _saveGame(points: int):
	var saveFile = FileAccess.open(savePath, FileAccess.WRITE)
		
	gameData.set(nivelActual, points)
	
	saveFile.store_var(gameData)
	saveFile = null

func _loadGame():
	if FileAccess.file_exists(savePath):
		var saveFile = FileAccess.open(savePath, FileAccess.READ)
		
		gameData = saveFile.get_var()
		saveFile = null
