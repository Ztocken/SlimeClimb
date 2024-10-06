extends Line2D


var queue: Array
@export var max_length: int = 1
func _process(delta):
	queue.push_front(get_parent().position - global_position)
	
	if queue.size() > max_length:
		queue.pop_back()
	
	clear_points()
	
	for point in queue: 
		add_point(point)
