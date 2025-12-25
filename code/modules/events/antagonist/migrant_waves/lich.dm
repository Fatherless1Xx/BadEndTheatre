/datum/round_event_control/antagonist/migrant_wave/lich
	name = "Wanderling Lich"
	wave_type = /datum/migrant_wave/lich

	weight = 6 //temp disabled 6
	max_occurrences = 2

	earliest_start = 20 MINUTES

	tags = list(
		TAG_ZIZO,
		TAG_HAUNTED,
		TAG_COMBAT,
	)

/datum/migrant_wave/lich
	name = "Wandering Lich"
	roles = list(
		/datum/migrant_role/lich = 1,
	)
	can_roll = FALSE

