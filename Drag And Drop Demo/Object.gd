extends Node2D

var selected = false
var rest_point
var rest_nodes = []

export(int, "Object 1", "Object 2", "Object 3") var object_id
var object_description
onready var anim = get_node("AnimatedSprite")

onready var ui_text = get_tree().get_root().get_node("TestScne/UI/InfoText")


func _ready():
	rest_nodes = get_tree().get_nodes_in_group("zone")
	for node in rest_nodes:
		if node.object_id == object_id:
			rest_point = node.global_position
	if object_id == 0:
		object_description = "obj1"
		anim.play("object1")
	elif object_id == 1:
		object_description = "obj2"
		anim.play("object2")
		anim.flip_h = true
		anim.flip_v = true
	elif object_id == 2:
		object_description = "obj3"
		anim.play("object2")
		anim.flip_h = false
		anim.flip_v = true
		anim.rotate(3)
	else:
		#object_description="Not Working"
		pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true
		
func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)
		
func _input(event):
	if event is InputEventMouseButton:
		#ui_text.clear()
		#ui_text.add_text(object_description)
		#print(object_description)
		
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
			var shortest_dist = 75
			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position)
				if distance < shortest_dist and  object_id == child.object_id:
					if child.is_goal:
						#play sound here
						child.select(child)
					rest_point = child.global_position
					shortest_dist = distance
					if(child.is_goal):
						print("Goal")



func _on_Area2D_mouse_entered():
	ui_text.clear()
	ui_text.add_text(object_description)
