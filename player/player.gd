extends CharacterBody2D

@export var gravity = 2
@export var speed = 300
@export var groundAcceleration = 800
@export var friction = 1500
@export var jumpForce = -700
@export var airAcceleration = 2000
@export var atackVelocity = 2
@export var iniExtraJump = 1
@export var iniHearts = 5
@export var iniPoints = 0

@onready var ui: Control = $CanvasLayer/UI
@onready var playerAni = $PlayerAni
@onready var atackColLe = $PlayerAtackAr/PlayerAtackLeCol
@onready var atackColRi = $PlayerAtackAr/PlayerAtackRiCol

enum states{
	IDLE,
	RUN,
	FALLING,
	ATACKING,
	DAMAGE
}

enum atackCol{
	RIGHT,
	LEFT
}

var extraJump: int = iniExtraJump
var hearts: int = iniHearts
var points: int = iniPoints
var actualState: states = states.IDLE
var facingRight: bool = true
var lastFacing: bool = facingRight
var invulnerability: bool = false

func _ready() -> void:
	add_to_group("player")
	ui._setLife(hearts)
	ui._setPoints(points)
	returnExtraJump()
	disableAtackCol()

func _physics_process(delta: float) -> void:
	var inputAxis = Input.get_axis("move_iz", "move_de")
	
	match actualState:

		states.IDLE:
			playerAni.play("idle")
			if inputAxis != 0:
				actualState = states.RUN
			if Input.is_action_just_pressed("atack"):
				actualState = states.ATACKING
			handleJump()
			
		states.RUN:
			playerAni.play("run")
			handleAcceleration(inputAxis, delta, groundAcceleration)
			
			handleHorizontalView(inputAxis)
			
			if inputAxis == 0:
				actualState = states.IDLE
			if Input.is_action_just_pressed("atack"):
				actualState = states.ATACKING
			handleJump()
			
		states.FALLING:
			handleAcceleration(inputAxis, delta, airAcceleration)
			handleJumpSecond()
			if velocity.y > 0:
				playerAni.play("fall")
			if is_on_floor():
				returnExtraJump()
				actualState = states.IDLE
			if Input.is_action_just_pressed("atack"):
				actualState = states.ATACKING
		
		states.ATACKING:
			playerAni.play("atack")
			handleAcceleration(inputAxis,delta, groundAcceleration)
			if facingRight:
				enableAtackCol(atackCol.RIGHT)
			else:
				enableAtackCol(atackCol.LEFT)
				
			if playerAni.frame == 3:
				actualState = states.IDLE
				disableAtackCol()
		
		states.DAMAGE:
			playerAni.play("hit")
			invulnerability = true
			if $PlayerDamagePityTimer.is_stopped():
				actualState = states.IDLE
				invulnerability = false
				

	handleSpeedAnimationVelocity()
	applyFriction(inputAxis, delta)
	applyGravity(delta)
	move_and_slide()
	#print(actualState)

func _dealDamage():
	if invulnerability: 
		return

	delHeart()
	playerAni.play("hit")
	$PlayerDamagePityTimer.start()
	actualState = states.DAMAGE
	if hearts == 0:
		die()

func _addPoints(amount: int):
	points+=amount

#Cuando entra un enemigo al ara de ataque
func _onEnterDamageArea(body: Node2D):
	if body.is_in_group("enemies"):
		body.dealDamage()
		_addPoints(3)

func die():
	set_physics_process(false)
	playerAni.play("death")
	$PlayerDeathTimer.start()
	await $PlayerDeathTimer.timeout
	# TODO Falta poner que vaya a la pantalla de muerte
	get_tree().reload_current_scene()

func delHeart():
	hearts-=1
	ui._setLife(hearts)

func returnExtraJump():
	extraJump = iniExtraJump

func handleAcceleration(inputAxis, delta, acceleration):
	if inputAxis != 0:
		if lastFacing != facingRight:
			velocity.x = velocity.x/2
		velocity.x = move_toward(velocity.x, speed*inputAxis, acceleration*delta)

func handleHorizontalView(inputAxis):
		if inputAxis != 0:
			lastFacing = facingRight
			if inputAxis < 0:
				facingRight = true
			else:
				facingRight = false
			playerAni.flip_h = facingRight

func handleSpeedAnimationVelocity():
	
	var velocityAni: float
	
	match actualState:
		states.RUN:
			velocityAni = velocity.length()/100
		states.ATACKING:
			velocityAni = atackVelocity
	playerAni.speed_scale = velocityAni

func handleJump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
			returnExtraJump()

func handleJumpSecond():
	if extraJump > 0 and Input.is_action_just_pressed("jump"):
		jump()
		extraJump-=1

func jump():
		actualState = states.FALLING
		velocity.y = jumpForce
		playerAni.play("jump")

func applyFriction(inputAxis, delta):
	if inputAxis==0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction*delta)

func applyGravity(delta):
	if not is_on_floor():
		velocity+=get_gravity() * delta * gravity

func enableAtackCol(col: atackCol):
	match col:
		atackCol.RIGHT:
			atackColRi.disabled = true
			atackColLe.disabled = false
			
		atackCol.LEFT:
			atackColRi.disabled = false
			atackColLe.disabled = true

func disableAtackCol():
		atackColRi.disabled = true
		atackColLe.disabled = true
