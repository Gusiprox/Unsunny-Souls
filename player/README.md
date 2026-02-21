# Documentación PLAYER

## Mecanicas

### Incluidas

- Personaje se mueve
- Personaje salta
- Personaje salta doble (se pueden poner mas)
- Personaje recibe daño
- UI vidas
- UI puntos (Aun por testear cuando ataque funcione)
- Personaje muere (Reinicia la escena)

### En desarrollo

- Personaje ataca
	- Animacion funciona bien, se puede cambiar su velocidad
	- Para detectar daño el enemigo debe incluir _dealDamage()
	- Falta conseguir un game filling mejor

### Falta

- Parry
- Segundo Golpe (animacion)

---
## Tecnicas

Se ha usado el patron de diseño `maquina de estados`

## Apuntes

Para poner un frame hay que darle 45 PX de tamaño en Y, y 35 en separacion Y

Hay una feature (bug) que si le das a saltar y dashear al mismo tiempo haces un dash en el aire (no eliminar esta gracioso)

```func handleSpeedAnimationVelocity():```: en esta funcion hay que controlar la velocidad de animacion en casos raros
