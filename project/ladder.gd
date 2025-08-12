extends Area2D

signal climb_changed(value: bool)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("climb_changed", true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("climb_changed", false)
