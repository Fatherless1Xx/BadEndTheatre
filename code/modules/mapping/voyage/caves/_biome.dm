/datum/cave_biome
	var/name = "Generic Cave"
	var/list/terrain_weights = list()
	var/list/flora_weights = list()
	var/list/feature_templates = list()
	var/flora_density = 0.08
	var/list/temperature_map
	var/list/moisture_map

	var/list/fauna_types = list() //! Populated on New()
	var/fauna_density = 3

/datum/cave_biome/proc/select_terrain(temperature, moisture, level)
	return pickweight(terrain_weights)

/datum/cave_biome/proc/select_flora(temperature, moisture, level)
	if(!flora_weights.len)
		return null
	return pickweight(flora_weights)


/datum/cave_biome/volcanic
	name = "Volcanic Cave"
	terrain_weights = list(
		/turf/open/floor/naturalstone = 60,
		/turf/open/floor/cobblerock = 30,
		/turf/open/floor/volcanic = 10
	)
	flora_weights = list(
		/obj/structure/flora/shroom_tree = 40,
	)
	feature_templates = list(
	)
	flora_density = 2

/datum/cave_biome/volcanic/New()
	. = ..()
	fauna_types = list(
		/mob/living/carbon/human/species/goblin/npc = new /datum/fauna_spawn_rule(
			min_temp = 0.4,
			max_temp = 0.9,
			min_moist = 0.2,
			max_moist = 0.8,
			min_h = 0,
			max_h = 1,
			weight = 100
		)
	)

/datum/cave_biome/volcanic/select_terrain(temperature, moisture, level)
	if(temperature > 0.7)
		if(prob(80))
			return /turf/open/floor/volcanic
		else
			return /turf/open/floor/cobblerock/alt

	if(temperature < 0.3)
		if(prob(70))
			return /turf/open/floor/naturalstone
		else
			return /turf/open/floor/cobblerock

	return pickweight(terrain_weights)

/datum/cave_biome/volcanic/select_flora(temperature, moisture, level)
	if(temperature < 0.7)
		return /obj/structure/flora/shroom_tree
	return null
