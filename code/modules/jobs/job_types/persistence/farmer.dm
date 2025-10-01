/datum/job/persistence/farmer
	title = "Farmer"
	tutorial = "You're a farmer, ensure the settlers don't starve."
	department_flag = PEASANTS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	outfit = /datum/outfit/farmer_p
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

/datum/outfit/farmer_p/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		H.cmode_music = 'sound/music/cmode/towner/CombatTowner2.ogg'
	//general skills
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)

	//job specific skills
	H.adjust_skillrank(/datum/skill/labor/farming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/taming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)

	//stats
	H.change_stat(STATKEY_STR, pick(0,1))
	H.change_stat(STATKEY_CON, pick(0,1))
	H.change_stat(STATKEY_END, pick(0,1))

	//traits
	ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)

	//gear
	head = pick(/obj/item/clothing/head/strawhat, /obj/item/clothing/head/armingcap, /obj/item/clothing/head/fisherhat)
	armor = pick(/obj/item/clothing/armor/leather/vest, /obj/item/clothing/armor/gambeson/light/striped)
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	pants = pick(/obj/item/clothing/pants/trou, /obj/item/clothing/pants/tights/colored/random)
	shoes = /obj/item/clothing/shoes/boots/leather

	belt = pick(/obj/item/storage/belt/leather, /obj/item/storage/belt/leather/rope)

	beltl = /obj/item/weapon/sickle
	beltr = /obj/item/weapon/shovel/small
	backr = /obj/item/weapon/hoe
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/knife/villager = 1, /obj/item/recipe_book/agriculture = 1)

	r_hand = /obj/item/weapon/thresher
	l_hand = /obj/item/weapon/pitchfork
