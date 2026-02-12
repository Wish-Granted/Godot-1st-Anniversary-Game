extends Node2D



func _on_death_borders_body_entered(body: Node2D) -> void:
	print(body.name, " has been killed X_X")
	body.queue_free()
