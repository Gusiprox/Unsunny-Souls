extends Node2D

@export var minSpawnWait = 4
@export var maxSpawnWait = 10
@export var sceneScale = 1.0
@export var spawnSceneRel: PackedScene

@onready var timer = $SpawnerTimer

var canSpawn: bool = true

func  _ready() -> void:
	startTimer()
	
func _onSpawnerTimerTimeout() -> void:	
	if canSpawn:
		instanceScene()
	startTimer()

func instanceScene():
	var scene = spawnSceneRel.instantiate()
	#scene.position = position
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
		canSpawn = false

func _onSpawnerArBodyExit(body: Node2D) -> void:
	if body.is_in_group("player"):
		canSpawn = true
