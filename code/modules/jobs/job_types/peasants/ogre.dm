/datum/job/ogre
	title = "Ogre"
	tutorial = "A hulking wanderer from Gronn. Townsfolk tolerate you for your strength and coin, but few dare to stand in your way."
	display_order = JDO_OGRE
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	department_flag = PEASANTS
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	bypass_lastclass = TRUE
	allowed_races = list(SPEC_ID_OGRE)
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/ogre
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/outfit/ogre/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/armor/plate/ogre
	shirt = /obj/item/clothing/shirt/ogre
	pants = /obj/item/clothing/pants/tights/ogre
	shoes = /obj/item/clothing/shoes/boots/ogre
	gloves = /obj/item/clothing/gloves/leather/ogre
	wrists = /obj/item/clothing/wrists/bracers/ogre
	neck = /obj/item/clothing/neck/gorget/ogre
	belt = /obj/item/storage/belt/leather/ogre
	cloak = /obj/item/clothing/cloak/apron/ogre
	beltr = /obj/item/weapon/sword/long/greatsword/zwei/ogre
	beltl = /obj/item/weapon/mace/cudgel/ogre
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/reagent_containers/food/snacks/meat/steak, /obj/item/reagent_containers/glass/bottle/waterskin)

	if(H)
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_CON, 1)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
