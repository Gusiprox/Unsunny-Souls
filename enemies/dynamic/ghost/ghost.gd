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

func _ready() -> void:
	add_to_group(groupEnemies)
	enemyAnimations.play(idleAnimation)

func _physics_process(_delta: float) -> void:
	velocity.y = Verticalspeed
		
	if is_on_wall():
		horizontalWay = -horizontalWay
		reactivateSearchCollisions()
		
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

func _dealDamage() -> int:
	die()
	return points

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

func _on_ghost_ar_search_up_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		verticalWay = -1
		Verticalspeed = Horizontalspeed

func _on_ghost_ar_search_down_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		verticalWay = 1
		Verticalspeed = Horizontalspeed

func _on_ghost_ar_search_up_body_exited(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		Verticalspeed = 0

func _on_ghost_ar_search_down_body_exited(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		Verticalspeed = 0

func die() -> void:
	enemyCollisions.set_deferred("disabled", true)
	attackArea.set_deferred("monitoring", false)
	set_physics_process(false)
	enemyAnimations.play(deathAnimation)
	await enemyAnimations.animation_finished
	queue_free()

func reactivateSearchCollisions() -> void:
	TimerReactivateSearch.start()
	enemyRightSearchCollisions.set_deferred("disabled", true)
	enemyLeftSearchCollisions.set_deferred("disabled", true)
	await TimerReactivateSearch.timeout
	enemyRightSearchCollisions.set_deferred("disabled", false)
	enemyLeftSearchCollisions.set_deferred("disabled", false)
