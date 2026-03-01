# Unsunny Souls

## Integrantes del grupo
- Aitor Rebato
- Sara Pérez
- Erik de la Cruz

## Índice
- [Unsunny Souls](#unsunny-souls)
	- [Integrantes del grupo](#integrantes-del-grupo)
	- [Índice](#índice)
	- [Conceptualización](#conceptualización)
	- [Arte](#arte)
	- [Programación](#programación)
		- [Jugador](#jugador)
		- [Enemigos](#enemigos)
			- [Estáticos](#estáticos)
			- [Dinámicos](#dinámicos)
		- [Spawner](#spawner)
		- [Corazón](#corazón)
		- [Terreno y fondo](#terreno-y-fondo)
		- [Menus](#menus)
			- [Menú de inicio](#menú-de-inicio)
			- [Menú de controles](#menú-de-controles)
			- [Menú de muerte](#menú-de-muerte)
	- [Elementos destacables](#elementos-destacables)

## Conceptualización

Nuestro videojuego trata de un caballero que se encuentra en una arena en la que aparecen monstruos, el objetivo es en derrotar a la mayor cantidad de enemigos posibles, para conseguir la mayor cantidad de puntos, antes de ser derrotado.

El juego es un plataformero 2D donde el jugador cuenta con 5 puntos de vida y podrá atacar, saltar, saltar una vez en el aire y rodar en el suelo para esquivar ataques, también habrá un coleccionable con forma de corazón en el nivel que recuperará un punto de vida y un contador de puntos. 

Tenemos diferentes niveles diseñados de forma distinta y con 2 tipos enemigos que iran apareciendo con el paso del tiempo, uno terrestre y otro volador, ambos serán hostiles y perseguiran al jugador, además el volador desaparecerá tras atacar.

Será de estética medieval fantasiosa al contar con un caballero en armadura que ataca con una espada, un enemigo no-muerto con una guadaña y un fantasma.

Al abrir el juego se verá la pantalla de inicio con las opciones de jugar al nivel que tú selecciones o a uno aleatorio y cerrar el juego, al seleccionar un nivel se cargará un escenario con tu personaje, una imagen de fondo y enemigos, arriba a la derecha se podrá ver la salud del jugador y la cantidad de puntos que tiene. Al quedarse sin puntos de vida saldrá una pantalla de fin de partida con las opciones de volver a intentarlo, salir al menú principal y cerrar el juego.

Los controles son:
- **A** para moverse a la izquierda
- **D** para moverse a la derecha
- **Space** para saltar
- **J** para atacar, se atacará con la espada por lo que el rango será limitado
- **Shift (Mayus)** para rodar

## Arte

Los sprites de los jugadores, enemigos, escenarios, fondos, música, sonidos, fuentes y etc se han obtenido de diferentes páginas donde los autores publican sus diseños sin derechos de autor. Sin embargo, la barra de salud del jugador ha sido diseñada por nosotros.

Aquí puede ver las páginas donde hemos obtenido los distintos recursos son:

- [Jugador](https://aamatniekss.itch.io/fantasy-knight-free-pixelart-animated-character)
- [Enemigos](https://darkpixel-kronovi.itch.io/undead-executioner)
- [Corazón](https://miguelnero.itch.io/hearth)
- [Escenarios](https://sismodyn.itch.io/ancientforest)
- [Pinchos](https://omniclause.itch.io/spikes)
- [Marco de sangre]()
- Fondos
- - [Fondo del nivel](https://brullov.itch.io/oak-woods)
- - [Fondo del menú de inicio]()
- - [Fondo del menú de muerte]()
- Sonidos
- - [Sonido de ataque](https://freesound.org/people/Streety/sounds/30247/)
- - [Sonido de jugador siendo atacado]()
- - [Sonido de jugador muriendo]()
- - [Sonido de muerte del enemigo](https://pixabay.com/sound-effects/horror-creepy-whisper-472369/)
- Música
- - [Música menu principal](https://pixabay.com/es/music/cl%C3%A1sico-moderno-medieval-escape-420206/)
- - [Música nivel 1](https://pixabay.com/es/music/titulo-principal-medieval-adventure-270566/)
- - [Música menu muerte](https://pixabay.com/es/music/grupo-acústico-medieval-star-shorter-version-371376/)
- Fuentes
- - [Fuente menus](https://ninjikin.itch.io/font-antiquity-script)
- - [Fuente puntos](https://managore.itch.io/m5x7)

## Programación

Para la realización de este videojuego se han usado una variedad de escenas que se explican a continuación:

### Jugador

### Enemigos

#### Estáticos

En nuestro juego contamos con un enemigo dinámico, un pincho, creado con un nodo de Area2D que contiene dos nodos, uno para introducir el sprite y otro para proporcionarle un área de colisión.

En el script creado para este enemigo se encuentran dos funciones:

- Función **_ready()** que añade al pincho al grupo enemies.
```gdscript
func _ready() -> void:
	add_to_group("enemies")
```


- Función **_on_body_entered(body: Node2D)**, que comprueba si es el jugador el que está en contacto con él y que contiene el método. Si se cumple el if, llama al método _dealSpikeDamage() presente en el script del jugador, el cual gestiona el daño que recibe y devuelve al jugador a una posición segura previa a haber colisionado con el pincho.

```gdscript
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_method("_dealSpikeDamage"):
		body._dealSpikeDamage()
```

#### Dinámicos

Para la creación de los 2 enemigos se han usado una escena por cada enemigo: 

- Undead: Enemigo terrestre con una guadaña sin posibilidades de saltar

- Ghost: Pequeño fantasma que vuela por el escenario y desaparecer colisionar con el jugador

Ambos cuentan con métodos como ```add_to_group(groupEnemies)``` para añadirles al grupo de enemigos para que puedan atacar y ser atacados por el jugador, se ha usado un area2D junto a un CollisionShape2D para que ataque al jugador y además se han usado otros para detectar al jugador cuando se acerca lo suficiente y moverse para perseguirlo, para lograr esto se ha usado la variable way (sentido) y dependiendo de si se encontraba a la derecha o izquierda se cambiaba el valor de este.

```gdscript
func _on_undead_ar_search_left_body_entered(body: Node2D) -> void:
	if body.is_in_group(groupPlayer):
		way = -1
		enemyAnimations.flip_h = true
```

Al ser atacados los enemigos desaparecen y otorgan al jugador una puntuación en base al enemigo que eran.

```gdscript
func _dealDamage() -> int:
	die()
	return points

func die() -> void:
	enemyCollisions.set_deferred("disabled", true)
	attackArea.set_deferred("monitoring", false)
	set_physics_process(false)
	
	deathAudio.play()
	enemyAnimations.play(deathAnimation)
	
	await enemyAnimations.animation_finished
	queue_free()
```

Para los fantasmas se han tenido que operar tanto con valores horizontales como verticales para la realización del vuelo como ```Horizontalspeed Verticalspeed``` o ```HorizontalWay VerticalWay``` y a su mismo tiempo se han tenido que usar funciones que eviten que abandonen el mapa cuando el jugador saliese de su rango de visión ```_on_ghost_ar_search_up_body_exited```

### Spawner

### Corazón

Se ha añadido un objeto, el corazón, creando un nodo Area2D con un AnimatedSprite2D en el que se ha introducido una animación y un nodo para gestionar sus colisiones.

En el script creado para este objeto se encuentran dos funciones:

- Función **_ready()**, en la que se reproduce la animación creada para el objeto.

```gdscript
func _ready():
	$HeartAni.play("default")
```

- Función **_on_body_entered(body: Node2D)**, que comprueba que el objeto que ha entrado en contacto con él es parte del grupo player y, de ser así, llama al método que se encuentra en el script del jugador _addHealth(), que recupera un punto de salud del jugador, en caso de que no tenga toda la vida. Para terminar llama al método queue_free() para eliminarse.

```gdscript
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body._addHealth()
		queue_free()
```

### Terreno y fondo

Para la creación del terreno se ha utilizado un nodo TileMapLayer. Se le ha introducido un tileset, que ha sido configurado para que tenga colisiones.

Para el fondo se ha usado una escena llamada **fondo** que cuenta con un ParallaxBackground que contiene tres ParallaxLayers, cada una de ellas con una imagen que puestas todas juntas nos da el fondo.

### Menus

#### Menú de inicio

Se ha creado un nodo Control y dentro de él se han introducido los siguientes nodos:

- **Sprite2D**, para añadir la imágen del fondo.
- **VBoxContainer**, donde se han metido los tres botones principales del menú (jugar, controles y salir).
- **Label**, para mostrar el nombre del juego.
- **Panel**, en el que se introducen los nodos del submenú mostrado al presionar el botón jugar.
  - **ScrollContainer** que contiene un **CenterContainer** que a su vez contiene un **VBoxContainer**. La razón por la que se ha utilizado ésta estructura es porque, si los niveles disponibles sobrepasan el tamaño otorgado para que se muestren, se superpondrían con los botones inferiores o se saldrían del panel. Sin embargo, utilizando un ScrollContainer, al superar el espacio otorgado, los botones de cada nivel disponibles se pueden observar despazandose hacia abajo con la rueda del ratón. El nodo CenterContainer es para tenerlos centrados.
  - **Button** (btnRandom), que se utiliza para que el propio juego escoja un nivel en vez de que lo haga el jugador.
  - **Button** (btnReturn), que se utiliza para cerrar el submenú.
- **AudioStreamPlayer2D**, utilizado para reproducir la música del menú en bucle.
- **Control** (MenuControls), que abre un menú en el que el jugador puede consultar los controles del juego.

En el script creado para ésta escena los métodos importantes son:

- Función **_ready()**, en la que se utiliza un método randomize() para que el número aleatorio obtenido en el botón random sea realmente aleatorio, ya que genera una nueva semilla cada vez que ejecutas el juego. Vuelve el panél de niveles invisible para que no se vea inicialmente y llama a la función crearBotonesNiveles() para que se creen todos los botones de los niveles disponibles.

```gdscript
func _ready():
	randomize()
	panelNiveles.visible = false
	crearBotonesNiveles()
```

- Función **crearBotonesNiveles()**, en la que se utiliza un bucle for para crear los botones de cada nivel guardado en la variable **niveles**, asignando el nombre que le corresponde a cada nivel. Cuando se presiona el botón de un nivel, se llama a la función **_onNivelPressed(nivelPath: String)**, se asigna la ruta que le corresponde. Además, la función gestiona el tamaño y la fuente de los botones creados.

```gdscript
@export var btnFont: FontFile = preload("res://menus/menu_start/font/antiquity-print.ttf")

var niveles = [
	{"ruta": "res://environment/levels/nivel_1.tscn", "nombre": "Bosque"},
	{"ruta": "res://environment/levels/nivel_2.tscn", "nombre": "Cueva Boscosa"}
]

func crearBotonesNiveles():
	for i in range(niveles.size()):
		var btn = Button.new()
		btn.text = niveles[i]["nombre"]
		
		if btnFont:
			btn.add_theme_font_override("font", btnFont)
			btn.add_theme_font_size_override("font_size", 14)
			
		btn.pressed.connect(Callable(self, "_onNivelPressed").bind(niveles[i]["ruta"]))
		conNiveles.add_child(btn)

func _onNivelPressed(nivelPath: String):
	Global.nivelActual = nivelPath
	get_tree().change_scene_to_file(nivelPath)
```

- Función **_on_btn_random_pressed()**, en la que se genera un número aleatorio en un rango de 0 al tamaño del array de niveles. Este número se utiliza en la posición del array, con la ruta del nivel correspondiente a esa posición obtenida, que además se guarda en una variable que posteriormente se utilizará en el menú de muerte.

```gdscript
func _on_btn_random_pressed() -> void:
	var index = randi_range(0, niveles.size() - 1)
	var nivelAleatorio = niveles[index]["ruta"]
	Global.nivelActual = nivelAleatorio
	get_tree().change_scene_to_file(nivelAleatorio)	

```

#### Menú de controles



#### Menú de muerte

Se ha creado un nodo **Control (MenuDead)** y dentro de él se han introducido los siguientes nodos:

- **Sprite2D (imgMenuDead)**, para añadir la imágen del fondo.
-  **VBoxContainer (conMenuDead)**, donde se han introducido los siguientes nodos:
   -  **Label (lblDeath)**, para mostrar un texto de muerte.
   -  **Label (lblPoints)**, donde se van a mostrar la cantidad de puntos obtenidos en la partida del jugador.
   -  **Button (btnRetry)**, para volver a intentar jugar el nivel.
   -  **Button (btnMainMenu)**, para volver al menú principal.
   -  **Button (btnExit)**, para salir del juego.
- **AudioStreamPlayer2D (audioMenuDead)**, utilizado para reproducir la música del menú en bucle.

En el script creado para ésta escena las funciones importantes son:

- Función **_ready()**, en la que se cargan los puntos obtenidos por el jugador antes de morir y posteriormente se muestran por pantalla utilizando una etiqueta.

```gdscript
func _ready():
	Global._loadGame()
	lblPoints.text = "Puntos: " + str(Global.gameData.get(Global.nivelActual, 0))
```

- Función **_on_btn_reload_pressed()**, que devuelve al jugador al mapa en el que estaba antes de morir, utilizando la variable global **nivelActual**, en la que se ha guardado el nivel escogido en el menú de inicio.

```gdscript
func _on_btn_reload_pressed():
	var ruta = Global.nivelActual
	get_tree().change_scene_to_file(ruta)
```


## Elementos destacables

Para asegurarse de que los enemigos no ignoraban al jugador al colisionar con una pared o al no poder avanzar para no caerse se ha usado el siguiente método para reiniciar las colisiones de buscar al jugador.

```gdscript
func resetSearchCollisions() -> void:
	TimerReactivateSearch.start()
	
	enemyRightSearchCollisions.set_deferred("disabled", true)
	enemyLeftSearchCollisions.set_deferred("disabled", true)
	
	await TimerReactivateSearch.timeout
	
	enemyRightSearchCollisions.set_deferred("disabled", false)
	enemyLeftSearchCollisions.set_deferred("disabled", false)
```
