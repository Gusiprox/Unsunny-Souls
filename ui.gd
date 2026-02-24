extends Control

@onready var pointsText = $UILbl
@onready var uiAni = $UIAni

var lastCoins: int
var lastHearts: int

var anims = [
	"0to1",
	"1to2",
	"2to3",
	"3to4",
	"4to5"
]

func _ready() -> void:
	uiAni.frame = 5
	lastCoins = 0
	lastHearts = 5

func _setLife(count: int):
	if count > 5 or count < 0:
		return
		
	if count == 5:
		uiAni.play("4to5")
		return
	if count > lastHearts:
		uiAni.play(anims[count-1])
	else:
		uiAni.play_backwards(anims[count])
	lastHearts = count

func _setPoints(count: int):
	pointsText.text = parseToPoints(count)

func parseToPoints(count: int) -> String:
	if count >= 10000:
		return "9999"

	const POINTS_LENGHT: int = 4
	var countString = str(count)

	while countString.length() != POINTS_LENGHT:
		countString = "0"+countString
	return countString
