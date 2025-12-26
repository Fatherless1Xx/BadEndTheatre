/datum/job/seelie
	title = "Seelie"
	tutorial = "A tiny fae whose magic is better spent helping others than fighting. Use your tricks and spells to brighten the days of the townsfolk."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_SEELIE
	faction = FACTION_TOWN
	total_positions = 6
	spawn_positions = 1
	bypass_lastclass = TRUE
	magic_user = TRUE

	allowed_races = list(SPEC_ID_SEELIE)
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = ALL_AGES_LIST

	outfit = /datum/outfit/seelie
	give_bank_account = FALSE

	spells = list(
		/datum/action/cooldown/spell/status/seelie_dust,
		/datum/action/cooldown/spell/seelie_call_beast,
		/datum/action/cooldown/spell/seelie_strip,
		/datum/action/cooldown/spell/seelie_drain,
		/datum/action/cooldown/spell/seelie_replenish,
		/datum/action/cooldown/spell/seelie_kiss,
		/datum/action/cooldown/spell/projectile/water_bolt,
		/datum/action/cooldown/spell/aoe/repulse
	)

/datum/outfit/seelie/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/sandals
	pants = /obj/item/clothing/pants/trou/shadowpants
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	cloak = /obj/item/clothing/cloak/half/colored/random
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/weapon/knife/dagger/steel
	backl = /obj/item/storage/backpack/satchel

	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)

	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_PER, 1)
