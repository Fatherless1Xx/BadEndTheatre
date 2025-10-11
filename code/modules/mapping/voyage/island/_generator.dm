/datum/island_generator
	var/size_x = 100
	var/size_y = 100
	var/datum/island_biome/biome
	var/turf/water_turf = /turf/open/water/ocean
	var/turf/deep_water_turf = /turf/open/water/ocean/deep
	var/turf/wall_turf = /turf/closed/mineral/random
	var/island_threshold = 0.3
	var/beach_width = 2
	var/beach_noise_scale = 0.15
	var/min_ocean_border = 5
	var/ocean_depth = 5
	var/smoothing_passes = 1
	var/seed = 0
	var/feature_attempts = 5
	var/min_feature_distance = 15

	///commonly modified
	var/height_frequency = 0.22
	var/height_threshold = 0.5
	var/temperature_frequency = 0.20
	var/moisture_frequency = 0.20
	var/noise_influence = 0.5

	// Simplex noise parameters
	var/noise_scale = 0.02
	var/octaves = 6
	var/gain = 0.5
	var/lacunarity = 2.0

	// Persistent noise generators
	var/datum/noise_generator/noise
	var/datum/noise_generator/beach_noise
	var/datum/noise_generator/height_noise
	var/datum/noise_generator/temperature_noise
	var/datum/noise_generator/moisture_noise

/datum/island_generator/New(datum/island_biome/selected_biome, sx = 100, sy = 100, _noise_influence = 0.5,  _temperature_frequency = 0.2, _moisture_frequency = 0.2, _height_frequency = 0.22, _height_threshold = 0.5)
	..()
	temperature_frequency = _temperature_frequency
	moisture_frequency = _moisture_frequency
	noise_influence = _noise_influence
	height_threshold = _height_threshold
	height_frequency = _height_frequency

	size_x = sx
	size_y = sy
	biome = selected_biome
	seed = rand(1, 999999)

	//we make noises seperately basically as a seed storage
	noise = new /datum/noise_generator(seed)
	noise.octaves = octaves
	noise.gain = gain
	noise.lacunarity = lacunarity
	noise.frequency = noise_scale

	beach_noise = new /datum/noise_generator(seed + 54321)
	beach_noise.octaves = 3
	beach_noise.gain = 0.5
	beach_noise.lacunarity = 2.0
	beach_noise.frequency = beach_noise_scale

	height_noise = new /datum/noise_generator(seed + 12345)
	height_noise.octaves = 3
	height_noise.gain = 0.5
	height_noise.lacunarity = 2.0
	height_noise.frequency = height_frequency

	temperature_noise = new /datum/noise_generator(seed + 99999)
	temperature_noise.octaves = 4
	temperature_noise.gain = 0.5
	temperature_noise.lacunarity = 2.0
	temperature_noise.frequency = temperature_frequency

	moisture_noise = new /datum/noise_generator(seed + 77777)
	moisture_noise.octaves = 4
	moisture_noise.gain = 0.5
	moisture_noise.lacunarity = 2.0
	moisture_noise.frequency = moisture_frequency

/datum/island_generator/proc/get_noise(x, y)
	return noise.fbm2(x, y)

/datum/island_generator/proc/get_beach_noise(x, y)
	return beach_noise.fbm2(x, y)

/datum/island_generator/proc/get_height_noise(x, y)
	return height_noise.fbm2(x, y)

/datum/island_generator/proc/get_temperature_noise(x, y)
	return temperature_noise.fbm2(x, y)

/datum/island_generator/proc/get_moisture_noise(x, y)
	return moisture_noise.fbm2(x, y)


/datum/island_generator/proc/generate_deferred(turf/bottom_left_corner, datum/controller/subsystem/terrain_generation/subsystem, datum/terrain_generation_job/job)
	set waitfor = FALSE

	if(!bottom_left_corner)
		return FALSE

	var/start_x = bottom_left_corner.x
	var/start_y = bottom_left_corner.y
	var/start_z = bottom_left_corner.z

	var/list/island_map = list()
	var/list/height_map = list()
	var/list/temperature_map = list()
	var/list/moisture_map = list()

	// Phase 1: Generate noise maps
	var/tiles_processed = 0
	var/total_tiles = size_x * size_y

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(x < min_ocean_border || x >= (size_x - min_ocean_border) || y < min_ocean_border || y >= (size_y - min_ocean_border))
				continue

			var/noise_val = get_noise(x, y)
			var/distance_factor = get_distance_factor(x, y)
			var/normalized_noise = (noise_val + 1) / 2
			var/value = normalized_noise - (distance_factor * (1 - noise_influence))

			if(value > island_threshold)
				island_map["[x],[y]"] = TRUE

				var/height_noise_val = get_height_noise(x, y)
				var/normalized_height = (height_noise_val + 1) / 2
				var/height_value = max(0, min(biome.max_height, round(normalized_height * biome.max_height)))
				height_map["[x],[y]"] = height_value

				var/temp_noise = get_temperature_noise(x, y)
				temperature_map["[x],[y]"] = (temp_noise + 1) / 2

				var/moist_noise = get_moisture_noise(x, y)
				moisture_map["[x],[y]"] = (moist_noise + 1) / 2

			tiles_processed++
			if(tiles_processed % 500 == 0)
				if(job)
					job.progress = 50 + (tiles_processed / total_tiles) * 10 // 50-60% for noise
				CHECK_TICK

	// Phase 2: Smooth island and heights
	for(var/i = 1 to smoothing_passes)
		island_map = smooth_island(island_map)
		CHECK_TICK

	height_map = smooth_heights(height_map, island_map)
	CHECK_TICK

	var/list/distance_map = calculate_distance_map_fast(island_map)
	CHECK_TICK

	biome.temperature_map = temperature_map
	biome.moisture_map = moisture_map

	// Phase 3: Generate water
	var/list/water_distance_map = list()
	var/list/water_queue = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(!island_map["[x],[y]"])
				var/turf/T = locate(start_x + x, start_y + y, start_z)
				if(T)
					T.ChangeTurf(deep_water_turf)
			else
				for(var/dx = -1 to 1)
					for(var/dy = -1 to 1)
						if(dx == 0 && dy == 0)
							continue
						var/wx = x + dx
						var/wy = y + dy
						if(!island_map["[wx],[wy]"] && wx >= 0 && wx < size_x && wy >= 0 && wy < size_y)
							var/water_key = "[wx],[wy]"
							if(!(water_key in water_distance_map))
								water_distance_map[water_key] = 0
								water_queue += water_key

		if(x % 10 == 0)
			if(job)
				job.progress = 60 + (x / size_x) * 10 // 60-70% for water setup
			CHECK_TICK

	// Spread shallow water
	var/water_tiles_processed = 0
	while(water_queue.len)
		var/current = water_queue[1]
		water_queue.Cut(1, 2)

		var/list/coords = splittext(current, ",")
		var/x = text2num(coords[1])
		var/y = text2num(coords[2])
		var/current_dist = water_distance_map[current]

		if(current_dist < ocean_depth)
			var/turf/T = locate(start_x + x, start_y + y, start_z)
			if(T)
				T.ChangeTurf(water_turf)

			var/spread_chance = 100 - (current_dist / ocean_depth * 40)

			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue

					if(!prob(spread_chance))
						continue

					var/nx = x + dx
					var/ny = y + dy

					if(nx < 0 || nx >= size_x || ny < 0 || ny >= size_y)
						continue

					if(island_map["[nx],[ny]"])
						continue

					var/neighbor_key = "[nx],[ny]"

					if(neighbor_key in water_distance_map)
						continue

					water_distance_map[neighbor_key] = current_dist + 1
					water_queue += neighbor_key

		water_tiles_processed++
		if(water_tiles_processed % 200 == 0)
			CHECK_TICK

	// Phase 4: Place terrain tiles
	var/list/mainland_tiles = list()
	var/list/beach_tiles = list()
	tiles_processed = 0

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(!island_map["[x],[y]"])
				continue

			var/dist_to_water = distance_map["[x],[y]"] || 0
			var/height = height_map["[x],[y]"] || 0
			var/temperature = temperature_map["[x],[y]"] || 0.5
			var/moisture = moisture_map["[x],[y]"] || 0.5

			var/turf/T = locate(start_x + x, start_y + y, start_z)
			if(!T)
				continue

			var/is_beach = FALSE
			if(height == 0)
				var/beach_noise_val = get_beach_noise(x, y)
				var/normalized_beach_noise = (beach_noise_val + 1) / 2

				var/beach_chance = 0
				if(dist_to_water <= beach_width)
					var/distance_factor = 1 - (dist_to_water / beach_width)
					beach_chance = (distance_factor * 70) + (normalized_beach_noise * 30)

					if(prob(beach_chance))
						is_beach = TRUE

			if(is_beach)
				T.ChangeTurf(biome.beach_turf)
				beach_tiles += list(list("turf" = T, "x" = x, "y" = y, "temperature" = temperature, "moisture" = moisture, "height" = height))
			else
				var/turf_type = biome.select_terrain(temperature, moisture, height)
				T.ChangeTurf(turf_type)
				mainland_tiles += list(list("turf" = T, "x" = x, "y" = y, "temperature" = temperature, "moisture" = moisture, "height" = height))

			if(height > 0)
				build_elevation(start_x + x, start_y + y, start_z, height, dist_to_water, temperature, moisture)

			tiles_processed++
			if(tiles_processed % 200 == 0)
				if(job)
					job.progress = 70 + (tiles_processed / total_tiles) * 15 // 70-85% for terrain
				CHECK_TICK

	// Phase 5: Place features
	var/list/simple_mainland = list()
	for(var/list/tile_data in mainland_tiles)
		simple_mainland += tile_data["turf"]
	place_features(simple_mainland, distance_map)
	CHECK_TICK

	// Phase 6: Spawn flora and fauna
	spawn_flora_poisson(mainland_tiles, beach_tiles, start_x, start_y)
	CHECK_TICK

	spawn_fauna_poisson(mainland_tiles, beach_tiles)
	CHECK_TICK

	if(job)
		job.progress = 100

	return TRUE

/datum/island_generator/proc/generate(turf/bottom_left_corner)
	if(!bottom_left_corner)
		return FALSE

	var/start_x = bottom_left_corner.x
	var/start_y = bottom_left_corner.y
	var/start_z = bottom_left_corner.z

	var/list/island_map = list()
	var/list/height_map = list()
	var/list/temperature_map = list()
	var/list/moisture_map = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(x < min_ocean_border || x >= (size_x - min_ocean_border) || y < min_ocean_border || y >= (size_y - min_ocean_border))
				continue

			var/noise_val = get_noise(x, y)
			var/distance_factor = get_distance_factor(x, y)
			var/normalized_noise = (noise_val + 1) / 2
			var/value = normalized_noise - (distance_factor * (1 - noise_influence))

			if(value > island_threshold)
				island_map["[x],[y]"] = TRUE

				var/height_noise_val = get_height_noise(x, y)
				var/normalized_height = (height_noise_val + 1) / 2
				var/height_value = max(0, min(biome.max_height, round(normalized_height * biome.max_height)))
				height_map["[x],[y]"] = height_value

				var/temp_noise = get_temperature_noise(x, y)
				temperature_map["[x],[y]"] = (temp_noise + 1) / 2

				var/moist_noise = get_moisture_noise(x, y)
				moisture_map["[x],[y]"] = (moist_noise + 1) / 2

	for(var/i = 1 to smoothing_passes)
		island_map = smooth_island(island_map)

	height_map = smooth_heights(height_map, island_map)

	var/list/distance_map = calculate_distance_map_fast(island_map)

	biome.temperature_map = temperature_map
	biome.moisture_map = moisture_map

	var/list/water_distance_map = list()
	var/list/water_queue = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(!island_map["[x],[y]"])
				var/turf/T = locate(start_x + x, start_y + y, start_z)
				if(T)
					T.ChangeTurf(deep_water_turf)
			else
				for(var/dx = -1 to 1)
					for(var/dy = -1 to 1)
						if(dx == 0 && dy == 0)
							continue
						var/wx = x + dx
						var/wy = y + dy
						if(!island_map["[wx],[wy]"] && wx >= 0 && wx < size_x && wy >= 0 && wy < size_y)
							var/water_key = "[wx],[wy]"
							if(!(water_key in water_distance_map))
								water_distance_map[water_key] = 0
								water_queue += water_key

	while(water_queue.len)
		var/current = water_queue[1]
		water_queue.Cut(1, 2)

		var/list/coords = splittext(current, ",")
		var/x = text2num(coords[1])
		var/y = text2num(coords[2])
		var/current_dist = water_distance_map[current]

		if(current_dist < ocean_depth)
			var/turf/T = locate(start_x + x, start_y + y, start_z)
			if(T)
				T.ChangeTurf(water_turf)

			var/spread_chance = 100 - (current_dist / ocean_depth * 40)

			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue

					if(!prob(spread_chance))
						continue

					var/nx = x + dx
					var/ny = y + dy

					if(nx < 0 || nx >= size_x || ny < 0 || ny >= size_y)
						continue

					if(island_map["[nx],[ny]"])
						continue

					var/neighbor_key = "[nx],[ny]"

					if(neighbor_key in water_distance_map)
						continue

					water_distance_map[neighbor_key] = current_dist + 1
					water_queue += neighbor_key

	var/list/mainland_tiles = list()
	var/list/beach_tiles = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(!island_map["[x],[y]"])
				continue

			var/dist_to_water = distance_map["[x],[y]"] || 0
			var/height = height_map["[x],[y]"] || 0
			var/temperature = temperature_map["[x],[y]"] || 0.5
			var/moisture = moisture_map["[x],[y]"] || 0.5

			var/turf/T = locate(start_x + x, start_y + y, start_z)
			if(!T)
				continue

			var/is_beach = FALSE
			if(height == 0)
				var/beach_noise_val = get_beach_noise(x, y)
				var/normalized_beach_noise = (beach_noise_val + 1) / 2

				var/beach_chance = 0
				if(dist_to_water <= beach_width)
					var/distance_factor = 1 - (dist_to_water / beach_width)
					beach_chance = (distance_factor * 70) + (normalized_beach_noise * 30)

					if(prob(beach_chance))
						is_beach = TRUE

			if(is_beach)
				T.ChangeTurf(biome.beach_turf)
				beach_tiles += list(list("turf" = T, "x" = x, "y" = y, "temperature" = temperature, "moisture" = moisture, "height" = height))
			else
				var/turf_type = biome.select_terrain(temperature, moisture, height)
				T.ChangeTurf(turf_type)
				mainland_tiles += list(list("turf" = T, "x" = x, "y" = y, "temperature" = temperature, "moisture" = moisture, "height" = height))

			if(height > 0)
				build_elevation(start_x + x, start_y + y, start_z, height, dist_to_water, temperature, moisture)

	var/list/simple_mainland = list()
	for(var/list/tile_data in mainland_tiles)
		simple_mainland += tile_data["turf"]
	place_features(simple_mainland, distance_map)

	spawn_flora_poisson(mainland_tiles, beach_tiles, start_x, start_y)
	spawn_fauna_poisson(mainland_tiles, beach_tiles)

	return TRUE

/datum/island_generator/proc/spawn_flora_poisson(list/mainland_tiles, list/beach_tiles, start_x, start_y)
	// Mainland flora
	if(mainland_tiles.len > 0 && biome.flora_density > 0)
		var/min_radius = biome.flora_density
		var/max_radius = min_radius * 1.5

		var/list/coord_to_tile = list()
		for(var/list/tile_data in mainland_tiles)
			coord_to_tile["[tile_data["x"]],[tile_data["y"]]"] = tile_data

		var/list/samples = noise.poisson_disk_sampling(0, size_x - 1, 0, size_y - 1, min_radius, max_radius)

		for(var/list/sample in samples)
			var/sx = round(sample[1])
			var/sy = round(sample[2])

			var/list/tile_data = coord_to_tile["[sx],[sy]"]
			if(!tile_data)
				continue

			var/temperature = tile_data["temperature"]
			var/moisture = tile_data["moisture"]
			var/height = tile_data["height"]
			var/turf/T = tile_data["turf"]

			var/flora_type = biome.select_flora(temperature, moisture, height)
			if(flora_type)
				if(ispath(flora_type, /obj/effect/flora_patch_spawner))
					new flora_type(T, temperature, moisture, biome)
				else
					new flora_type(T)

	// Beach flora
	if(beach_tiles.len > 0 && biome.beach_flora_density > 0)
		var/min_radius = biome.beach_flora_density
		var/max_radius = min_radius * 1.5

		var/list/coord_to_tile = list()
		for(var/list/tile_data in beach_tiles)
			coord_to_tile["[tile_data["x"]],[tile_data["y"]]"] = tile_data

		var/list/samples = noise.poisson_disk_sampling(0, size_x - 1, 0, size_y - 1, min_radius, max_radius)

		for(var/list/sample in samples)
			var/sx = round(sample[1])
			var/sy = round(sample[2])

			var/list/tile_data = coord_to_tile["[sx],[sy]"]
			if(!tile_data)
				continue

			var/temperature = tile_data["temperature"]
			var/moisture = tile_data["moisture"]
			var/height = tile_data["height"]
			var/turf/T = tile_data["turf"]

			var/flora_type = biome.select_beach_flora(temperature, moisture, height)
			if(flora_type)
				new flora_type(T)

/datum/island_generator/proc/spawn_fauna_poisson(list/mainland_tiles, list/beach_tiles)
	if(!biome.fauna_types || !biome.fauna_types.len || biome.fauna_density <= 0)
		return

	var/min_radius = biome.fauna_density
	var/max_radius = min_radius * 2

	// Build combined lookup with beach flag
	var/list/coord_to_tile = list()
	var/list/beach_coords = list()

	for(var/list/tile_data in mainland_tiles)
		coord_to_tile["[tile_data["x"]],[tile_data["y"]]"] = tile_data

	for(var/list/tile_data in beach_tiles)
		var/key = "[tile_data["x"]],[tile_data["y"]]"
		coord_to_tile[key] = tile_data
		beach_coords[key] = TRUE

	var/list/samples = noise.poisson_disk_sampling(0, size_x - 1, 0, size_y - 1, min_radius, max_radius)

	for(var/list/sample in samples)
		var/sx = round(sample[1])
		var/sy = round(sample[2])
		var/key = "[sx],[sy]"

		var/list/tile_data = coord_to_tile[key]
		if(!tile_data)
			continue

		var/temperature = tile_data["temperature"]
		var/moisture = tile_data["moisture"]
		var/height = tile_data["height"]
		var/turf/T = tile_data["turf"]
		var/is_beach = beach_coords[key]

		var/spawn_chance = 100
		if(height > 2)
			spawn_chance *= 0.5

		var/temp_factor = 1 - abs(temperature - 0.5) * 2
		spawn_chance *= (0.5 + temp_factor * 0.5)

		if(!prob(spawn_chance))
			continue

		var/list/valid_fauna = list()
		for(var/fauna_path in biome.fauna_types)
			var/datum/fauna_spawn_rule/rule = biome.fauna_types[fauna_path]

			if(temperature < rule.min_temperature || temperature > rule.max_temperature)
				continue
			if(moisture < rule.min_moisture || moisture > rule.max_moisture)
				continue
			if(height < rule.min_height || height > rule.max_height)
				continue
			if(rule.beach_only && !is_beach)
				continue
			if(rule.no_beach && is_beach)
				continue

			valid_fauna[fauna_path] = rule.spawn_weight

		if(valid_fauna.len)
			var/chosen = weighted_pick_fauna(valid_fauna)
			if(chosen)
				new chosen(T)

/datum/island_generator/proc/weighted_pick_fauna(list/weights)
	var/total = 0
	for(var/item in weights)
		total += weights[item]

	var/pick = rand(1, total)
	var/current = 0

	for(var/item in weights)
		current += weights[item]
		if(pick <= current)
			return item

	return pick(weights)

/datum/island_generator/proc/build_elevation(x, y, z, height, dist_to_water, temperature, moisture)
	for(var/level = 1 to height)
		var/turf/below = locate(x, y, z + level - 1)
		var/turf/current = locate(x, y, z + level)

		if(!current || !below)
			continue

		for(var/obj/structure/structure in below)
			qdel(structure)

		below.ChangeTurf(wall_turf)

		if(level == height)
			var/turf_type = biome.select_terrain(temperature, moisture, level)
			current.ChangeTurf(turf_type)


/datum/island_generator/proc/smooth_heights(list/height_map, list/island_map)
	var/list/new_heights = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(!island_map["[x],[y]"])
				continue

			var/total_height = height_map["[x],[y]"] || 0
			var/count = 1

			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue

					var/check_x = x + dx
					var/check_y = y + dy

					if(island_map["[check_x],[check_y]"])
						total_height += height_map["[check_x],[check_y]"] || 0
						count++

			new_heights["[x],[y]"] = round(total_height / count)

	var/list/extra_smooth = list()
	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(!island_map["[x],[y]"])
				continue

			var/current = new_heights["[x],[y]"] || 0
			var/total = current
			var/count = 1

			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue

					var/check_x = x + dx
					var/check_y = y + dy

					if(island_map["[check_x],[check_y]"])
						total += new_heights["[check_x],[check_y]"] || 0
						count++

			extra_smooth["[x],[y]"] = round(total / count)

	return extra_smooth

/datum/island_generator/proc/calculate_distance_map_fast(list/island_map)
	var/list/distance_map = list()
	var/list/queue = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			if(!island_map["[x],[y]"])
				continue

			var/is_edge = FALSE
			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue
					if(!island_map["[x+dx],[y+dy]"])
						is_edge = TRUE
						break
				if(is_edge)
					break

			if(is_edge)
				distance_map["[x],[y]"] = 0
				queue += "[x],[y]"

	while(queue.len)
		var/current = queue[1]
		queue.Cut(1, 2)

		var/list/coords = splittext(current, ",")
		var/x = text2num(coords[1])
		var/y = text2num(coords[2])
		var/current_dist = distance_map["[x],[y]"]

		for(var/dx = -1 to 1)
			for(var/dy = -1 to 1)
				if(dx == 0 && dy == 0)
					continue

				var/nx = x + dx
				var/ny = y + dy
				var/neighbor_key = "[nx],[ny]"

				if(!island_map[neighbor_key])
					continue

				if(neighbor_key in distance_map)
					continue

				distance_map[neighbor_key] = current_dist + 1
				queue += neighbor_key

	return distance_map

/datum/island_generator/proc/place_features(list/valid_tiles, list/distance_map)
	if(!biome.feature_templates || !biome.feature_templates.len)
		return

	var/list/placed_features = list()
	var/list/island_map = list()
	var/list/height_map = list()

	var/base_x = valid_tiles[1]:x
	var/base_y = valid_tiles[1]:y

	for(var/turf/T in valid_tiles)
		var/rel_x = T.x - base_x
		var/rel_y = T.y - base_y
		island_map["[rel_x],[rel_y]"] = TRUE

		var/height = 0
		var/turf/check = T
		while(istype(GET_TURF_BELOW(check), /turf/closed/wall))
			height++
			check = GET_TURF_BELOW(check)
		height_map["[rel_x],[rel_y]"] = height

	var/list/weighted_templates = list()
	for(var/template_type in biome.feature_templates)
		var/datum/island_feature_template/template = new template_type()
		weighted_templates[template] = template.spawn_weight

	for(var/attempt = 1 to feature_attempts)
		if(!valid_tiles.len || !weighted_templates.len)
			break

		var/datum/island_feature_template/feature_template = weighted_pick(weighted_templates)
		var/turf/spawn_loc = find_valid_template_location(feature_template, valid_tiles, placed_features, island_map, height_map, distance_map, base_x, base_y)

		if(!spawn_loc)
			continue

		var/datum/map_template/template = new feature_template.template_path()
		if(template && template.load(spawn_loc, centered = FALSE))
			placed_features += spawn_loc

			var/blocked_radius = max(feature_template.width, feature_template.height) + min_feature_distance
			for(var/turf/check in valid_tiles)
				var/dx = spawn_loc.x - check.x
				var/dy = spawn_loc.y - check.y
				if(dx * dx + dy * dy < blocked_radius * blocked_radius)
					valid_tiles -= check

/datum/island_generator/proc/find_valid_template_location(datum/island_feature_template/feature_template, list/valid_tiles, list/placed_features, list/island_map, list/height_map, list/distance_map, base_x, base_y)
	var/max_attempts = 20

	for(var/i = 1 to max_attempts)
		var/turf/candidate = pick(valid_tiles)

		var/too_close = FALSE
		for(var/turf/placed in placed_features)
			var/dx = candidate.x - placed.x
			var/dy = candidate.y - placed.y
			if(dx * dx + dy * dy < min_feature_distance * min_feature_distance)
				too_close = TRUE
				break

		if(too_close)
			continue

		if(!validate_template_requirements(feature_template, candidate, island_map, height_map, distance_map, base_x, base_y))
			continue

		return candidate

	return null

/datum/island_generator/proc/validate_template_requirements(datum/island_feature_template/feature_template, turf/origin, list/island_map, list/height_map, list/distance_map, base_x, base_y)
	var/origin_rel_x = origin.x - base_x
	var/origin_rel_y = origin.y - base_y
	var/origin_height = height_map["[origin_rel_x],[origin_rel_y]"] || 0
	var/origin_distance = distance_map["[origin_rel_x],[origin_rel_y]"] || 0

	if(origin_height < feature_template.min_elevation || origin_height > feature_template.max_elevation)
		return FALSE

	if(origin_distance < feature_template.min_distance_from_water || origin_distance > feature_template.max_distance_from_water)
		return FALSE

	if(!feature_template.allow_on_beach)
		var/turf/origin_turf = locate(origin.x, origin.y, origin.z)
		if(istype(origin_turf, biome.beach_turf))
			return FALSE

	var/min_height = origin_height
	var/max_height = origin_height

	for(var/x = 0 to feature_template.width - 1)
		for(var/y = 0 to feature_template.height - 1)
			var/check_x = origin.x + x
			var/check_y = origin.y + y
			var/rel_x = check_x - base_x
			var/rel_y = check_y - base_y

			if(!island_map["[rel_x],[rel_y]"])
				return FALSE

			var/turf/T = locate(check_x, check_y, origin.z)
			if(!T || istype(T, /turf/open/water))
				return FALSE

			var/tile_height = height_map["[rel_x],[rel_y]"] || 0
			min_height = min(min_height, tile_height)
			max_height = max(max_height, tile_height)

			if(!feature_template.allow_on_beach && istype(T, biome.beach_turf))
				return FALSE

	var/height_variance = max_height - min_height
	if(feature_template.require_flat_terrain && height_variance > 0)
		return FALSE
	if(height_variance > feature_template.max_height_variance)
		return FALSE

	return TRUE

/datum/island_generator/proc/get_distance_factor(x, y)
	var/center_x = size_x / 2
	var/center_y = size_y / 2
	var/dx = (x - center_x) / center_x
	var/dy = (y - center_y) / center_y
	var/dist = sqrt(dx * dx + dy * dy)
	return dist ** 1.5

/datum/island_generator/proc/smooth_island(list/island_map)
	var/list/new_map = list()

	for(var/x = 0 to size_x - 1)
		for(var/y = 0 to size_y - 1)
			var/neighbors = count_neighbors(island_map, x, y)

			if(island_map["[x],[y]"])
				new_map["[x],[y]"] = (neighbors >= 3)
			else
				new_map["[x],[y]"] = (neighbors >= 6)

	return new_map

/datum/island_generator/proc/count_neighbors(list/island_map, x, y)
	var/count = 0
	for(var/dx = -1 to 1)
		for(var/dy = -1 to 1)
			if(dx == 0 && dy == 0)
				continue
			if(island_map["[x+dx],[y+dy]"])
				count++
	return count

/datum/island_generator/proc/weighted_pick(list/weights)
	var/total = 0
	for(var/item in weights)
		total += weights[item]

	var/pick = rand(1, total)
	var/current = 0

	for(var/item in weights)
		current += weights[item]
		if(pick <= current)
			return item

	return pick(weights)
