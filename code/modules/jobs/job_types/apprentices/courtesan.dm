/datum/job/courtesan
	title = "Court Courtesan"
	tutorial = "Trained to delight and obey, you exist to entertain the court at a noble's whim. Your brand ensures the nobles know exactly whom you belong to."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SERVANT
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL
	allowed_sexes = list(FEMALE)
	blacklisted_species = list(SPEC_ID_SEELIE)
	outfit = /datum/outfit/courtesan
	give_bank_account = TRUE
	can_have_apprentices = FALSE
	forced_flaw = /datum/charflaw/indentured

/datum/outfit/courtesan/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/leather/exoticsilkbelt
	shirt = /obj/item/clothing/shirt/exoticsilkbra
	shoes = /obj/item/clothing/shoes/anklets
	neck = /obj/item/clothing/neck/leathercollar
	backl = /obj/item/storage/backpack/satchel
	beltl = /obj/item/storage/belt/pouch/coins/poor
	beltr = /obj/item/key/manor

	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
		H.change_stat(STATKEY_SPD, 1)
		H.change_stat(STATKEY_CON, 1)
		var/datum/inspiration/I = new /datum/inspiration(H)
		I.grant_inspiration(H, bard_tier = BARD_T3)
		ADD_TRAIT(H, TRAIT_BARDIC_TRAINING, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_INDENTURED, JOB_TRAIT)
		ADD_TRAIT(H, TRAIT_GOODLOVER, JOB_TRAIT)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)

/datum/job/courtesan/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	// Give them a choice of instrument
	spawned.select_equippable(player_client, list(
		"Harp" = /obj/item/instrument/harp,
		"Lute" = /obj/item/instrument/lute,
		"Accordion" = /obj/item/instrument/accord,
		"Guitar" = /obj/item/instrument/guitar,
		"Flute" = /obj/item/instrument/flute,
		"Drum" = /obj/item/instrument/drum,
		"Hurdy-Gurdy" = /obj/item/instrument/hurdygurdy,
		"Viola" = /obj/item/instrument/viola),
		message = "Choose your instrument.",
		title = "XYLIX"
	)
