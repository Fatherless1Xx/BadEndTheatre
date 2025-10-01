/// A basis for migrants allowing for infinite selection and setting relevant variables.
/// Positions and min_pq should not be changed.
/datum/job/migrant
	abstract_type = /datum/job/migrant
	title = "Migrant"
	department_flag = OUTSIDERS
	job_flags = NONE
	display_order = JDO_MIGRANT
	faction = FACTION_TOWN
	total_positions = 0
	spawn_positions = 0
	min_pq = -999

	allowed_races = RACES_PLAYER_ALL
	allowed_sexes = list(MALE, FEMALE)

/// For cases where you have an advanced class migrant with no migrant job.
/datum/job/migrant/generic
