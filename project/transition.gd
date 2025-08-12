extends Area2D
@export var transitionRoom: PackedScene
var ButtonScript = preload("res://button.gd") # for referencing the State enum

func level_completed():
	var button_list = []
	var num_of_buttons_completed = 0
	
	for button in get_parent().get_node("buttons").get_children():
		button_list.append(button)
		if button.state == ButtonScript.State.activated:
			num_of_buttons_completed += 1
	
	if num_of_buttons_completed == button_list.size():
		return true
	else:
		return false
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if level_completed():
			get_tree().change_scene_to_packed(transitionRoom)
			
