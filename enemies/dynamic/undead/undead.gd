extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var points: int = 10
@export var speed: int = 100
var sentido: int = 1

func _ready() -> void:
	add_to_group("enemies")
	$UndeadAni.play("idle")

func _on_undead_ar_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body._dealDamage()
		$UndeadAni.play("attack")
		set_physics_process(false)
		await $UndeadAni.animation_finished
		set_physics_process(true)
		$UndeadAni.play("idle")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if is_on_wall():
		sentido = -sentido
		
	if sentido == 1 && $RayIzquierdo.is_colliding():
		velocity.x = speed
		$UndeadAni.flip_h = false
	else:
		sentido = -1
	
	if sentido == -1 && $RayDerecho.is_colliding():
		velocity.x = -speed
		$UndeadAni.flip_h = true
	else:
		sentido = 1

	move_and_slide()

func _dealDamage() -> int:
	$UndeadCol.set_deferred("disabled", true)
	$UndeadAr.monitoring = false
	set_physics_process(false)
	$UndeadAni.play("death")
	await $UndeadAni.animation_finished
	queue_free()
	return points
	
