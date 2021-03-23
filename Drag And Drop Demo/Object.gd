extends Node2D

var selected = false
var rest_point
var rest_nodes = []
var completed : bool = false


onready var bus_collision = get_node("AnimatedSprite/Area2D/bus")
onready var dish_collision = get_node("AnimatedSprite/Area2D/dish")
onready var left_solar_collision = get_node("AnimatedSprite/Area2D/left_solar")
onready var magnet_collision = get_node("AnimatedSprite/Area2D/magnet")
onready var right_solar_collision = get_node("AnimatedSprite/Area2D/right_solar")
onready var spectr_collision = get_node("AnimatedSprite/Area2D/spectr")
onready var sound_player = get_tree().get_root().get_node("TestScne/Sound")

export(int, "bus","dish","left_solar","magnet","right_solar","spectr") var object_id
var object_description
onready var anim = get_node("AnimatedSprite")

#change this when adding in ui sprite
onready var ui_text = get_tree().get_root().get_node("TestScne/UI/InfoText")

#Json Parse
var dict = {}
onready var file  = File.new()


func _ready():
	#Json Parse and assignment
	file.open("res://Json/json_data.tres", file.READ)
	var text = file.get_as_text()
	#print("Contents" + text)
	dict = JSON.parse(text).result
	#print(dict[2]["component"])
	file.close()
	
	
	
	rest_nodes = get_tree().get_nodes_in_group("zone")
	for node in rest_nodes:
		if node.object_id == object_id:
			rest_point = node.global_position
	if object_id == 0:
		object_description = dict[0]["component"]+":\n\t"+dict[0]["description"]
		anim.play("bus")
		bus_collision.disabled = false
	elif object_id == 1:
		object_description = dict[1]["component"]+":\n\t"+dict[1]["description"]
		anim.play("dish")
		dish_collision.disabled = false
	elif object_id == 2:
		object_description = dict[2]["component"]+":\n\t"+dict[2]["description"]
		anim.play("left_solar")
		left_solar_collision.disabled = false
	elif object_id == 3:
		object_description = dict[4]["component"]+":\n\t"+dict[4]["description"]
		anim.play("magnet")
		magnet_collision.disabled = false
	elif object_id == 4:
		object_description = dict[3]["component"]+":\n\t"+dict[3]["description"]
		anim.play("right_solar")
		right_solar_collision.disabled = false
	elif object_id == 5:
		object_description = dict[5]["component"]+":\n\t"+dict[5]["description"]
		anim.play("spectr")
		spectr_collision.disabled = false
	else:
		object_description="Not Working"
		anim.play("a_blank")
		pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		selected = true
		
func _physics_process(delta):
	if selected and not completed:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	else:
		global_position = lerp(global_position, rest_point, 10 * delta)
		
func _input(event):
	if event is InputEventMouseButton:
		#ui_text.clear()
		#ui_text.add_text(object_description)
		#print(object_description)
		
		if event.button_index == BUTTON_LEFT and not event.pressed and not completed:
			selected = false
			var shortest_dist = 75
			for child in rest_nodes:
				var distance = global_position.distance_to(child.global_position)
				if distance < shortest_dist and  object_id == child.object_id:
					if child.is_goal:
						#play sound here
						child.select(child)
						completed = true
						sound_player.play()
					rest_point = child.global_position
					shortest_dist = distance
					if(child.is_goal):
						print("Goal")



func _on_Area2D_mouse_entered():
	ui_text.clear()
	ui_text.add_text(object_description)
