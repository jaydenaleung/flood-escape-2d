extends Area2D

enum State {
	activated,
	active,
	group, # if it is State.group then it is considered active (active group button)
	inactive
}

var state = State.inactive
var textures = {
	State.activated: "activated",
	State.active: "active",
	State.group: "group",
	State.inactive: "inactive"
}
var isGroup: bool # indicates if it is to be a group button, but not necessiarily that it is automatically active as a group button

func _ready():
	update()

func _process(_delta): # looping function every frame
	update()

func update(): 
	compute_state() # update itself
	$AnimatedSprite2D.play(textures[state]) # load textures	
	
func _on_body_entered(body: Node2D) -> void: # use signals to detect if the button has been pressed
	if body.is_in_group("player"):
		if state == State.active or state == State.group:
			state = State.activated
		
		update()
	
func get_button_list():
	var buttons = []
	for button in get_parent().get_children():
		buttons.append(button)
	return buttons

func compute_button_readiness():
	var self_value: int
	var buttons = get_button_list()
	for button in buttons:
		if button == self:
			self_value = buttons.find(self)
			break
	
	if state == State.activated:
		return false
	elif self.name == "button1":
		return true
	elif buttons[self_value-1].state == State.activated:
		return true
	else:
		return false

func compute_state():
	if get_tree().root.get_child(0).name == "Room3" and self.name == "button1": # check if it is a group button (the only one is Room 3, Button 1)
		isGroup = true
	else:
		isGroup = false
	
	if not compute_button_readiness() and state != State.activated: # inactive button or inactive group button
		state = State.inactive
	elif compute_button_readiness(): # active button
		state = State.active
	elif isGroup and compute_button_readiness(): # active group button
		state = State.active
	else: # everything else assume is activated
		state = State.activated
