/datum/migrant_role/lich
	name = "Lich"
	antag_datum = /datum/antagonist/lich

/datum/migrant_role/harlequinn
	name = "Harlequinn"
	antag_datum = /datum/antagonist/harlequinn

/datum/migrant_wave/harlequinn
	name = "Harlequinn"
	roles = list(
		/datum/migrant_role/harlequinn = 1,
	)
	can_roll = FALSE

/datum/migrant_role/advclass/adventurer/maniac
	name = "Crazed Adventurer"
	antag_datum = /datum/antagonist/maniac

/datum/migrant_wave/maniac
	name = "Crazed Adventurer"
	roles = list(
		/datum/migrant_role/advclass/adventurer/maniac = 1,
	)
	can_roll = FALSE

/datum/migrant_role/advclass/adventurer/werewolf
	name = "Adventurer"
	antag_datum = /datum/antagonist/werewolf

/datum/migrant_wave/werewolf
	name = "Exiled Adventurer (Verevolf)"
	roles = list(
		/datum/migrant_role/advclass/adventurer/werewolf = 1,
	)
	can_roll = FALSE

/datum/migrant_role/advclass/adventurer/vampire
	name = "Adventurer"
	antag_datum = /datum/antagonist/vampire

/datum/migrant_wave/vampire
	name = "Exiled Adventurer (Vampire)"
	roles = list(
		/datum/migrant_role/advclass/adventurer/vampire = 1,
	)
	can_roll = FALSE
