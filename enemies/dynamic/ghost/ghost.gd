extends CharacterBody2D

@export var points: int = 20
@export var Horizontalspeed: int = 100
@export var Verticalspeed: int = 0

var horizontalWay: int = 1
var verticalWay: int = 0

var groupPlayer: String = "player"
var groupEnemies: String = "enemies"

var idleAnimation: String = "idle"
var deathAnimation: String = "death"

@onready var enemyAnimations = $GhostAni
@onready var enemyCollisions = $GhostCol
@onready var enemyLeftSearchCollisions = $GhostArSearchLeft/GhostColSearchLeft
@onready var enemyRightSearchCollisions = $GhostArSearchRight/GhostColSearchRight
@onready var attackArea = $GhostArAtk
@onready var TimerReactivateSearch = $TimerReactivateSearch
@onready var deathAudio = $GhostDeathAudio

func _ready() -> void:
	add_to_group(groupEnemies)
	enemyAnimations.play(idleAnimation)

# De normal la velocidad la tendremos en 0 al empezar para que solo pueda subir y bajar cuando el jugador esté lo suficientemente cerca
func _physics_process(_delta: float) -> void:
	velocity.y = Verticalspeed
		
	if is_on_wall():
		horizontalWay = -horizontalWay
		resetSearchCollisions()
		
	if horizontalWay == 1:
		velocity.x = Horizontalspeed
		enemyAnimations.flip_h = false
	
	if horizontalWay == -1:
		velocity.x = -Horizontalspeed
		enemyAnimations.flip_h = true
		
	if verticalWay == 1:
		velocity.y = Verticalspeed
		
	if verticalWay == -1:
		velocity.y = -Verticalspeed
		
	move_and_slide()

# Importante que la función morir no sea quien devuelva los puntos para lograr que el enemigo se autoddestruya al atacar al jugador
func _dealDamage() -> int:
	die()
	return points

# Al autodestruirse al atacar llamará a la función de morir
func _on_ghost_ar_atk_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		body._dealDamage()
		die()

func _on_ghost_ar_search_left_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		horizontalWay = -1
		enemyAnimations.flip_h = true

func _on_ghost_ar_search_right_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		horizontalWay = 1
		enemyAnimations.flip_h = false

# Si el jugador se acerca por arriba o abajo, haremos que el valor de velocidad vertical sea igual que el de la horizontal para que sean iguales y con el uso de los sentidos verticales podremos indicar si subir o bajar
func _on_ghost_ar_search_up_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		verticalWay = -1
		Verticalspeed = Horizontalspeed

func _on_ghost_ar_search_down_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		verticalWay = 1
		Verticalspeed = Horizontalspeed
		
# Cuando se salga el jugador de las colisiones de busqueda verticales se dejará de moverse arriba y abajo para evitar salirse del nivel o de quedarse atascado en el suelo
func _on_ghost_ar_search_up_body_exited(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		Verticalspeed = 0

func _on_ghost_ar_search_down_body_exited(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		Verticalspeed = 0

func resetSearchCollisions() -> void:
	TimerReactivateSearch.start()
	
	enemyRightSearchCollisions.set_deferred("disabled", true)
	enemyLeftSearchCollisions.set_deferred("disabled", true)
	
	await TimerReactivateSearch.timeout
	
	enemyRightSearchCollisions.set_deferred("disabled", false)
	enemyLeftSearchCollisions.set_deferred("disabled", false)

func die() -> void:
	enemyCollisions.set_deferred("disabled", true)
	attackArea.set_deferred("monitoring", false)
	set_physics_process(false)
	
	deathAudio.play()
	enemyAnimations.play(deathAnimation)
	await enemyAnimations.animation_finished
	
	queue_free()
