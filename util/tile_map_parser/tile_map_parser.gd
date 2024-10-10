extends Node2D

@export var tileMap: TileMap:
	set(new_tile_map):
		tileMap = new_tile_map
		create_objects()
@export var object_tileLayer_name = "objects"
@export var object_tileSet_name = "objects"
		
func create_objects():
	var objectLayerID = get_object_layer()
	var tileSetID = get_tile_id()
	for cellPos in tileMap.get_used_cells_by_id(objectLayerID, tileSetID):
		var cellCoordinate = tileMap.get_cell_atlas_coords(objectLayerID, cellPos)
		get_object_by_cell(cellCoordinate, cellPos)
	tileMap.clear_layer(objectLayerID)
		
func get_object_layer():
	for id in range(tileMap.get_layers_count()):
		if tileMap.get_layer_name(id) == object_tileLayer_name:
			return id

func get_tile_id():
	var tileSet = tileMap.tile_set
	for index in range(tileSet.get_source_count()):
		var id = tileSet.get_source_id(index)
		if tileSet.get_source(id).resource_name == object_tileSet_name:
			return id

func get_object_by_cell(coordinate:Vector2, spawnPosition:Vector2):
	var map = GameObjectManager.tile_objects
	if map.has(coordinate):
		var objectData = map.get(coordinate)
		if objectData.has("object"):
			var object = objectData.get("object")
			var sceneObject = object.instantiate()
			sceneObject.position = spawnPosition * 16
			if objectData.has("data"):
				for entry in objectData.get("data"):
					sceneObject.set(entry, objectData.get("data").get(entry))
			add_child(sceneObject)
