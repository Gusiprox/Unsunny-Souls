extends CharacterBody2D

@export var gravity = 2
@export var speed = 300
@export var groundAcceleration = 800
@export var friction = 1500
@export var jumpForce = -700
@export var dashForce = 550
@export var dashAnimationVelocity = 2
@export var airAcceleration = 2000
@export var attackVelocity = 2
@export var iniExtraJump = 1
@export var iniHearts = 5
@export var iniPoints = 0

@onready var ui: Control = $CanvasLayer/UI
@onready var playerAni = $PlayerAni
@onready var atackColLe = $PlayerAtackAr/PlayerAtackLeCol
@onready var atackColRi = $PlayerAtackAr/PlayerAtackRiCol
@onready var playerSoundAtack = $PlayerAtackSound
@onready var playerSoundDamage = $PlayerDamageSound
@onready var damageSprite = $CanvasLayer/DamageSprite
@onready var damagePityTimer = $PlayerDamagePityTimer

enum states{
	IDLE,
	RUN,
	FALLING,
	ATACKING,
	DAMAGE,
	DASH,
	ATACKING_SECOND
}

enum atackCol{
	RIGHT,
	LEFT
}

var extraJump: int = iniExtraJump
var hearts: int = iniHearts
var points: int = iniPoints
var actualState: states = states.IDLE
var facingLeft: bool = false
var lastFacing: bool = facingLeft
var invulnerability: bool = false
var safeZone: Vector2 = position
var playingAtackSound: bool = false
var isDeath: bool = false

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
			
			if is_on_floor():
				safeZone = position
			if !is_on_floor():
				actualState = states.FALLING
			if inputAxis != 0:
				actualState = states.RUN
			if Input.is_action_just_pressed("atack"):
				actualState = states.ATACKING
			handleJump()
			if Input.is_action_just_pressed("dash"):
				actualState = states.DASH
		states.RUN:
			playerAni.play("run")
			handleAcceleration(inputAxis, delta, groundAcceleration)
			
			handleHorizontalView(inputAxis)
			if is_on_floor():
				safeZone = position
			if inputAxis == 0:
				actualState = states.IDLE
			if Input.is_action_just_pressed("atack"):
				actualState = states.ATACKING
			handleJump()
			if Input.is_action_just_pressed("dash"):
				actualState = states.DASH
			
		states.FALLING:
			handleAcceleration(inputAxis, delta, airAcceleration)
			handleJumpSecond()
			handleHorizontalView(inputAxis)
			if velocity.y > 0:
				playerAni.play("fall")
			if is_on_floor():
				returnExtraJump()
				actualState = states.IDLE
			if Input.is_action_just_pressed("atack"):
				actualState = states.ATACKING
			if Input.is_action_just_pressed("dash"):
				actualState = states.DASH
		
		states.ATACKING:
			playerAni.play("atack")
	
			handleAcceleration(inputAxis,delta, groundAcceleration)
			decelerate()
			if facingLeft:
				enableAtackCol(atackCol.RIGHT)
			else:
				enableAtackCol(atackCol.LEFT)
				
			if playerAni.frame == 3:
				actualState = states.IDLE
				disableAtackCol()

			if (playerAni.frame >= 2) and Input.is_action_just_pressed("atack"):
				actualState = states.ATACKING_SECOND
				disableAtackCol()

		states.ATACKING_SECOND:
			playerAni.play("atack_second")
			
			handleAcceleration(inputAxis,delta, groundAcceleration)
			decelerate()
			if facingLeft:
				enableAtackCol(atackCol.RIGHT)
			else:
				enableAtackCol(atackCol.LEFT)
			if playerAni.frame == 5:
				playAtackSound(false)
				actualState = states.IDLE
				disableAtackCol()
				
			if (playerAni.frame >= 3) and Input.is_action_just_pressed("atack"):
				actualState = states.ATACKING
				playingAtackSound = false
				disableAtackCol()
		
		states.DAMAGE:
			if !isDeath:
				playerAni.play("hit")
			disableAtackCol()
			invulnerability = true
			if damagePityTimer.is_stopped() and !isDeath:
				actualState = states.IDLE
				invulnerability = false
				setDamagePity(false)
				playDamageSound(false)
		
		states.DASH:
			playerAni.play("dash")
			
			if facingLeft:
				velocity.x = dashForce * -1
			else:
				velocity.x = dashForce
			
			if playerAni.frame >= 9:
				invulnerability = false
				handlePhantomMode(false)
			else:
				invulnerability = true
				handlePhantomMode(true)
			if playerAni.frame == 11:
				actualState = states.IDLE
				decelerate()
	
	handleAudio()
	handleSpeedAnimationVelocity()
	applyFriction(inputAxis, delta)
	applyGravity(delta)
	move_and_slide()
	#print(actualState)

func _dealDamage():
	if invulnerability or isDeath: 
		return
	hitProcess()

func _dealSpikeDamage():
	position = safeZone
	velocity = Vector2(0,0)
	hitProcess()

func _addPoints(amount: int):
	points+=amount
	ui._setPoints(points)

func _addHealth():
	if hearts != iniHearts:
		hearts+=1
		ui._setLife(hearts)
	
#Cuando entra un enemigo al area de ataque
func _onEnterDamageArea(body: Node2D):
	if body.is_in_group("enemies"):
		var damagePoints = await body._dealDamage()
		_addPoints(damagePoints)

func playAtackSound(to: bool):
	if to:
		playerSoundAtack.play()
	else:
		playerSoundAtack.stop()

func playDamageSound(to: bool):
	if to:
		playerSoundDamage.play(0.2)
	else:
		playerSoundDamage.stop()

func setDamagePity(visibleTo: bool):
	damageSprite.visible = visibleTo

func hitProcess():
	delHeart()
	damagePityTimer.start()
	actualState = states.DAMAGE
	setDamagePity(true)
	playDamageSound(true)
	if hearts == 0:
		die()

func die():
	isDeath = true
	playerAni.play("death")
	handlePhantomMode(true)
	$PlayerDeathTimer.start()
	Global._saveGame(points)
	await $PlayerDeathTimer.timeout
	get_tree().change_scene_to_file("res://menus/menu_dead/menu_dead.tscn")

func delHeart():
	hearts-=1
	ui._setLife(hearts)

func returnExtraJump():
	extraJump = iniExtraJump

func handleAcceleration(inputAxis, delta, acceleration):
	if inputAxis != 0:
		if lastFacing != facingLeft:
			decelerate()
		velocity.x = move_toward(velocity.x, speed*inputAxis, acceleration*delta)

func decelerate():
	velocity.x = velocity.x/2
	
func handleHorizontalView(inputAxis):
		if inputAxis != 0:
			lastFacing = facingLeft
			if inputAxis < 0:
				facingLeft = true
			else:
				facingLeft = false
			playerAni.flip_h = facingLeft

func handleSpeedAnimationVelocity():
	
	var velocityAni: float
	match actualState:
		states.RUN:
			velocityAni = velocity.length()/100
		states.ATACKING:
			velocityAni = attackVelocity
		states.ATACKING_SECOND:
			velocityAni = attackVelocity+1
		states.DASH:
			velocityAni = dashAnimationVelocity
		_:
			velocityAni = 3
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

func handlePhantomMode(active: bool):
	if active:
		collision_mask &= ~2
		collision_layer &= ~2
	else:
		collision_mask |= 2
		collision_layer |= 2

func handleAudio():
	
	match actualState:
		states.ATACKING:
			if playingAtackSound == false:
				playerSoundAtack.play()
				playingAtackSound = true
		states.IDLE:
			playerSoundAtack.stop()
			playingAtackSound = false
