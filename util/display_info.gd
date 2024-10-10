extends Node

var font = preload("res://font/Kenney Mini.ttf")
func display_info(text:String, position: Vector2):
	var info_label = Label.new()
	info_label.global_position = position
	info_label.text = text
	info_label.z_index = 5
	info_label.label_settings = LabelSettings.new()
	
	var color = "#ffecd6"
	info_label.label_settings.font_color = color
	info_label.label_settings.font_size = 8
	info_label.label_settings.font = font
	
	call_deferred("add_child", info_label)
	
	await  info_label.resized
	info_label.pivot_offset = Vector2(info_label.size / 2)
	
	var tween= get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(info_label, "scale", Vector2.ZERO, 1).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await  tween.finished
	info_label.queue_free()
