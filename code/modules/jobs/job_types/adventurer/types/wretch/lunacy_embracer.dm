/datum/job/advclass/wretch/lunacyembracer
	title = "Lunacy Embracer"
	tutorial = "You have rejected and terrorized civilization in the name of nature. You run wild under the moon. A terror to townsfolk. A champion of Dendor."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(/datum/species/harpy)
	min_pq = 30
	outfit = /datum/outfit/wretch/lunacyembracer

/datum/outfit/wretch/lunacyembracer
	name = "Lunacy Embracer"

/datum/outfit/wretch/lunacyembracer/pre_equip(mob/living/carbon/human/H)
	..()

	to_chat(H, span_danger("You have abandoned your humanity to run wild under the moon. The call of nature fills your soul!"))

	ADD_TRAIT(H, TRAIT_NUDIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOOD_SWIM, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)

	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_LCK, 2)
	H.change_stat(STATKEY_INT, -2)
	H.change_stat(STATKEY_PER, -2)

	switch(H.patron?.type)
		if(/datum/patron/divine/dendor)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.grant_language(/datum/language/beast)

		if(/datum/patron/divine/noc)
			H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)

		if(/datum/patron/divine/abyssor)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)

		if(/datum/patron/divine/pestra)
			H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)

		if(/datum/patron/divine/eora)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)

		if(/datum/patron/divine/malum)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)

		if(/datum/patron/divine/ravox)
			H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)

		if(/datum/patron/divine/xylix)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)

	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.grant_to(H)

	wretch_select_bounty(H)
