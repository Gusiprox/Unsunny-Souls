extends Area2D


func _ready():
	$HeartAni.play("default")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		body.addHealth()
		queue_free()
