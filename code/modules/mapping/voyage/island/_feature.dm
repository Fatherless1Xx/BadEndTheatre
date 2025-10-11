/datum/island_feature_template
	var/name = "Generic Feature"
	var/datum/map_template/template_path
	var/width = 5 // Template width
	var/height = 5 // Template height
	var/min_distance_from_water = 5 // Minimum tiles from water edge
	var/max_distance_from_water = 999 // Maximum tiles from water edge
	var/allow_on_beach = FALSE // Can spawn on beach tiles
	var/min_elevation = 0 // Minimum elevation level
	var/max_elevation = 999 // Maximum elevation level
	var/require_flat_terrain = TRUE // Requires all tiles to be same height
	var/spawn_weight = 100 // Weight for random selection
	var/max_height_variance = 0 // Maximum height difference allowed within template area

/datum/island_feature_template/blackberry
	name = "Blackberry Field"
	template_path = /datum/map_template/world_feature/blackberry
	width = 7
	height = 9
	min_distance_from_water = 15
	allow_on_beach = FALSE
	min_elevation = 0
	max_elevation = 1
	spawn_weight = 50

/datum/island_feature_template/strawberry
	name = "Strawberry Field"
	template_path = /datum/map_template/world_feature/strawberry
	width = 11
	height = 10
	min_distance_from_water = 5
	allow_on_beach = FALSE
	min_elevation = 0
	max_elevation = 1
	spawn_weight = 100
