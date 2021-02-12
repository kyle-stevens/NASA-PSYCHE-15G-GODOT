extends Position2D

#func _ready():
	#print(get_tree().get_nodes_in_group("rest_zones"))

func _draw():
	draw_rect(Rect2(global_position.x, global_position.y, 75, 75), Color.blanchedalmond)
	#modulate.a = 0.05
	
func select():
	for child in get_tree().get_nodes_in_group("rest_zones_01"):
		child.deselect()
	modulate= Color.webmaroon
	#modulate.a = 0.05
	
	
func deselect():
	modulate = Color.white
	#modulate.a = 0.05
	
