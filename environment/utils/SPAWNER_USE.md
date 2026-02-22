# Uso de la escena `Spawner`

## Que hace

Su funcion es instanciar enemigos (principalmente) en escena en `tiempo de ejecucion`

## Uso

1. Crear un nodo2D vacio en la escena de nivel (donde quieras ponerlo) llamalo `spawners`

2. Dentro de este nodo `spawners`, vas a colocar todos los nodos spawner que necesites

3. Mueve cada spawner hacia donde quieras que se cree el enemigo (guiate por la hitbox naranja)
> Donde este la hitbox naranja no apareceran enemigos si el jugador esta encima

4. Dentro de los parametros del spawner coloca la `Spawn Scene Rel`, esta es la escena del enemigo (o lo que quieras crear) que se creara en ese lugar
> Los enemigos aparecen en el centro del cuadrado naranja

5. Puedes controlar los tiempo con el `Min/Max Spawn Wait` de las caracteristicas, medido en segundos

6. Si al crearse son muy grandes/pequeños modifica el `Scene Scale` es la escala de lo que quieras spawnear

7. Modificar `Limit In Scene` Para poner un limite de spawn, este limite funciona acorde a las entidades que el mismo tiene en ese momento, si se elimina una vuelve a poder spawnear otro

7. Pruebalo

## Dudas posibles

- ¿Se modifica el codigo?: **NO**, solo modifica las caracteristicas del spawner ya puesto en escena, piensa en ellos como objetos

-¿Pueden spawnear mas escenas un mismo spawner? no, solo esta pensada para una cada uno, si quieres otra crea otro spawner

- No funciona: reporta el bug

- No pongas el spawner muy cerca del suelo, puede bugearse
