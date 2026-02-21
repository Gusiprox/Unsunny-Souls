extends Control

func _ready() -> void:
	$UIAni.frame = 5

func _setLife(count: int):
	if count > 5 or count < 0:
		return
	$UIAni.frame = count

func _setPoints(count: int):
	$UILbl.text = parseToPoints(count)
	
func parseToPoints(count: int) -> String:
	if count >= 10000:
		return "9999"

	const POINTS_LENGHT: int = 4
	var countString = str(count)

	while countString.length() != POINTS_LENGHT:
		countString = "0"+countString
	return countString
