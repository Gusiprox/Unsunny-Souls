extends Node2D

@export var minSpawnWait = 4
@export var maxSpawnWait = 10
@export var sceneScale = 1.0
@export var limitInScene = 5
@export var spawnSceneRel: PackedScene

@onready var timer = $SpawnerTimer

var canSpawn: bool = true
var playerInside: bool = false
 
func  _ready() -> void:
	startTimer()
	
func _onSpawnerTimerTimeout() -> void:	
	
	if get_child_count()-2 >= limitInScene:
		canSpawn = false
	else :
		canSpawn = true
	
	if playerInside:
		canSpawn = false

	if canSpawn:
		instanceScene()
	startTimer()

func instanceScene():
	var scene = spawnSceneRel.instantiate()
	scene.scale = Vector2(sceneScale, sceneScale)
	add_child(scene)

func startTimer():
	
	timer.wait_time = getRandomNumber(minSpawnWait, maxSpawnWait)
	timer.start()

func getRandomNumber(minim: float, maxim: float) -> float:
	randomize()
	return randf_range(minim, maxim)
	

func _onSpawnerArBodyEntered(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerInside = true

func _onSpawnerArBodyExit(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerInside = false
		
