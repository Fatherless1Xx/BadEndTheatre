/datum/job/persistence/stonemason
	title = "Stonemason"
	tutorial = "You're a stonemason, ensure the settlement isn't a bunch of tents."
	department_flag = SERFS
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	outfit = /datum/outfit/stonemason_p
	cmode_music = 'sound/music/cmode/towner/CombatTowner.ogg'

/datum/outfit/stonemason_p/pre_equip(mob/living/carbon/human/H)
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
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)//climbing skill so they can climb whatever they built
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 2, TRUE)

	//stats
	H.change_stat(STATKEY_STR, pick(0,1))
	H.change_stat(STATKEY_CON, pick(0,1))
	H.change_stat(STATKEY_END, pick(0,1))

	//traits

	//gear
	head = pick(/obj/item/clothing/head/hatfur, /obj/item/clothing/head/hatblu, /obj/item/clothing/head/brimmed)
	armor = pick(/obj/item/clothing/armor/leather/vest, /obj/item/clothing/armor/gambeson/light/striped)
	shirt = /obj/item/clothing/shirt/undershirt/colored/random
	pants = pick(/obj/item/clothing/pants/trou, /obj/item/clothing/pants/tights/colored/random)
	shoes = /obj/item/clothing/shoes/boots/leather

	belt = pick(/obj/item/storage/belt/leather, /obj/item/storage/belt/leather/rope)
	belt = /obj/item/storage/belt/leather

	beltl = /obj/item/weapon/hammer/iron
	beltr = /obj/item/weapon/pick
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/recipe_book/masonry= 1, /obj/item/weapon/knife/villager = 1, /obj/item/weapon/chisel/iron = 1)
