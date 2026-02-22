extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var points: int = 10
@export var speed: int = 100
var way: int = 1

var groupPlayer: String = "player"
var groupEnemies: String = "enemies"

var idleAnimation: String = "idle"
var deathAnimation: String = "death"
var attackAnimation: String = "attack"

@onready var enemyAnimations = $UndeadAni
@onready var enemyCollisions = $UndeadCol
@onready var attackArea = $UndeadArAtk
@onready var enemyAttackCollisions = $UndeadArAtk/UndeadColAtk
@onready var enemyRightSearchCollisions = $UndeadArSearchRight/UndeadColSearchRight
@onready var enemyLeftSearchCollisions = $UndeadArSearchLeft/UndeadColSearchLeft
@onready var TimerReactivateSearch = $TimerReactivateSearch
@onready var leftRay = $RayLeft
@onready var rightRay = $RayRight

func _ready() -> void:
	add_to_group(groupEnemies)
	enemyAnimations.play(idleAnimation)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	if is_on_wall():
		way = -way
		reactivateSearchCollisions()
		
	if way == 1 && rightRay.is_colliding():
		velocity.x = speed
		enemyAnimations.flip_h = false
	else:
		way = -1
	
	if way == -1 && leftRay.is_colliding():
		velocity.x = -speed
		enemyAnimations.flip_h = true
	else:
		way = 1

	if (leftRay.is_colliding() == false || rightRay.is_colliding() == false):
		reactivateSearchCollisions()

	move_and_slide()

func _dealDamage() -> int:
	die()
	return points

func _on_undead_ar_atk_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		body._dealDamage()
		enemyAnimations.play(attackAnimation)
		enemyAttackCollisions.set_deferred("disabled", true)
		set_physics_process(false)
		await enemyAnimations.animation_finished
		enemyAttackCollisions.set_deferred("disabled", false)
		set_physics_process(true)
		enemyAnimations.play(idleAnimation)

func _on_undead_ar_search_left_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		way = -1
		enemyAnimations.flip_h = true

func _on_undead_ar_search_right_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		way = 1
		enemyAnimations.flip_h = false

func reactivateSearchCollisions() -> void:
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
	enemyAnimations.play(deathAnimation)
	await enemyAnimations.animation_finished
	queue_free()
