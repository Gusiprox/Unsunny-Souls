extends CharacterBody2D

@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var points: int = 10
@export var speed: int = 100
var sentido: int = 1

func _ready() -> void:
	$UndeadAni.play("idle")

func _on_undead_ar_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body._dealDamage()
		$UndeadAni.play("attack")
		speed = 0
		await $UndeadAni.animation_finished
		speed = 100
		$UndeadAni.play("idle")

func _physics_process(delta: float) -> void:
	# Establecemos la velocidad
	velocity.y += gravity * delta
	if is_on_wall():
		sentido = -sentido
		
	## Si el detector delantero está detectando suelo y vamos en esa dirección
	if sentido == 1 && $RayIzquierdo.is_colliding():
		velocity.x = speed
		$UndeadAni.flip_h = false
	else:
		sentido = -1
	
	## Si el detector trasero está detectando suelo y vamos en esa dirección
	if sentido == -1 && $RayDerecho.is_colliding():
		velocity.x = -speed
		$UndeadAni.flip_h = true
	else:
		sentido = 1

	# Refrescamos el juego
	move_and_slide()

func _dealDamage() -> int:
	$UndeadAni.play("death")
	queue_free()
	return points
