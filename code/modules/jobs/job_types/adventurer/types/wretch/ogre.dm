/datum/job/advclass/wretch/ogre
	abstract_type = /datum/job/advclass/wretch/ogre
	category_tags = list(CTAG_WRETCH)
	allowed_races = list(SPEC_ID_OGRE)
	blacklisted_species = list()
	total_positions = 1
	spawn_positions = 1
	department_flag = OUTSIDERS
	faction = FACTION_NEUTRAL
	bypass_lastclass = TRUE
	job_flags = (JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK)
	bypass_class_cat_limits = TRUE
	roll_chance = 100
/datum/job/advclass/wretch/ogre/avatar
	title = "Avatar of Graggar"
	tutorial = "A hulking avatar of Graggar. Smash, chop, or crush anything in your way."
	display_order = JDO_OGRE + 0.1
	allowed_races = list(SPEC_ID_OGRE)
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/wretch/ogre/avatar
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'
	total_positions = 2
	spawn_positions = 2

/datum/outfit/wretch/ogre/avatar/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/armor/plate/ogre
	shirt = /obj/item/clothing/shirt/ogre
	pants = /obj/item/clothing/pants/chainlegs/ogre
	shoes = /obj/item/clothing/shoes/boots/armor/ogre
	gloves = /obj/item/clothing/gloves/plate/ogre
	wrists = /obj/item/clothing/wrists/bracers/ogre
	neck = /obj/item/clothing/neck/gorget/ogre
	head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar/ogre
	belt = /obj/item/storage/belt/leather/ogre
	cloak = /obj/item/clothing/cloak/apron/ogre
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/mace/cudgel/ogre = 1, /obj/item/rope/chain = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/reagent_containers/glass/bottle/waterskin = 1)

	var/weapons = list(
		"Mace" = /obj/item/weapon/mace/goden/steel/ogre/graggar,
		"Axe" = /obj/item/weapon/greataxe/steel/doublehead/graggar/ogre,
		"Sword" = /obj/item/weapon/sword/long/greatsword/zwei/ogre
	)
	var/weaponchoice = input(H, "Choose your weapon.", "Weapon Selection") as anything in weapons
	if(weaponchoice)
		r_hand = weapons[weaponchoice]
	if(H)
		ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		H.change_stat(STATKEY_STR, 5)
		H.change_stat(STATKEY_CON, 5)
		H.change_stat(STATKEY_END, 5)
		H.change_stat(STATKEY_INT, -2)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)
		wretch_select_bounty(H)
