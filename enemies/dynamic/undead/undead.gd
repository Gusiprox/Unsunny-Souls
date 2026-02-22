extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var points: int = 10
@export var speed: int = 100
var sentido: int = 1

@onready var enemyAnimations = $UndeadAni
@onready var leftRay = $RayLeft
@onready var rightRay = $RayRight
@onready var enemyCollisions = $UndeadCol
@onready var enemyAttackCollisions = $UndeadArAtk/UndeadColAtk
@onready var enemySearchLeftCollisions = $UndeadArSearchLeft/UndeadColSearchLeft
@onready var enemySearchRightCollisions = $UndeadArSearchRight
@onready var attackArea = $UndeadArAtk

func _ready() -> void:
	add_to_group("enemies")
	enemyAnimations.play("idle")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	if is_on_wall():
		sentido = -sentido
		
	if sentido == 1 && rightRay.is_colliding():
		velocity.x = speed
		enemyAnimations.flip_h = false
	else:
		sentido = -1
	
	if sentido == -1 && leftRay.is_colliding():
		velocity.x = -speed
		enemyAnimations.flip_h = true
	else:
		sentido = 1

	move_and_slide()

func _dealDamage() -> int:
	enemyCollisions.set_deferred("disabled", true)
	attackArea.monitoring = false
	set_physics_process(false)
	enemyAnimations.play("death")
	await enemyAnimations.animation_finished
	queue_free()
	return points

func _on_undead_ar_atk_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body._dealDamage()
		enemyAnimations.play("attack")
		enemyAttackCollisions.set_deferred("disabled", true)
		set_physics_process(false)
		await enemyAnimations.animation_finished
		enemyAttackCollisions.set_deferred("disabled", false)
		set_physics_process(true)
		enemyAnimations.play("idle")

func _on_undead_ar_search_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sentido = -1
		enemyAnimations.flip_h = true

func _on_undead_ar_search_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		sentido = 1
		enemyAnimations.flip_h = false
