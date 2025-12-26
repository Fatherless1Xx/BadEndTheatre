/datum/round_event_control/antagonist/solo/rebel
	name = "Rebels"
	tags = list(
		TAG_MATTHIOS,
		TAG_COMBAT,
	)
	roundstart = TRUE
	antag_flag = ROLE_PREBEL
	shared_occurence_type = SHARED_HIGH_THREAT

	base_antags = 1
	maximum_antags = 3

	max_occurrences = 1

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/rebel
	antag_datum = /datum/antagonist/prebel/head

	weight = 4

	restricted_roles = list(
		"Monarch",
		"Consort",
		"Hand",
		"Captain",
		"Prince",
		"Priest",
		"Inquisitor",
		"Absolver",
		"Confessor",
		"Sacrestants",
		"Adept",
		"Assassin",
	)

/datum/round_event_control/antagonist/solo/rebel/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event/antagonist/solo/rebel
