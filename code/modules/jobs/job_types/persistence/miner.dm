/datum/job/persistence/miner
	title = "Mineworker"
	tutorial = "You're a mineworker, ensure the settlement has stone and ores."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	outfit = /datum/outfit/miner_p
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

/datum/outfit/miner_p/pre_equip(mob/living/carbon/human/H)
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
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)

	//stats
	H.change_stat(STATKEY_STR, pick(0,1))
	H.change_stat(STATKEY_CON, pick(1,2))
	H.change_stat(STATKEY_END, pick(1,2))

	//traits

	//gear
	head = /obj/item/clothing/head/helmet/leather/minershelm
	armor = pick(/obj/item/clothing/armor/leather/vest, /obj/item/clothing/armor/gambeson/light/striped)
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	pants = pick(/obj/item/clothing/pants/trou, /obj/item/clothing/pants/tights/colored/random)
	shoes = /obj/item/clothing/shoes/boots/leather

	belt = pick(/obj/item/storage/belt/leather, /obj/item/storage/belt/leather/rope)

	beltl = /obj/item/weapon/pick
	backr = /obj/item/weapon/shovel
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/flint = 1, /obj/item/weapon/knife/villager = 1)
