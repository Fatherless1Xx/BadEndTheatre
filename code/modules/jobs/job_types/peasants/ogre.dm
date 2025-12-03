/datum/job/advclass/wretch/ogre/dumdum
	title = "Dum Dum"
	tutorial = "You left Gronn because you could not find enough to eat there, and mean men kept firing arrows at you! Now you are here, and you are hungry. Time to find food!"
	display_order = JDO_OGRE
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	department_flag = OUTSIDERS
	faction = FACTION_NEUTRAL
	total_positions = 1
	spawn_positions = 1
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

/datum/job/advclass/wretch/ogre/avatar
	title = "Avatar of Graggar"
	tutorial = "A hulking avatar of Graggar. Smash, chop, or crush anything in your way."
	display_order = JDO_OGRE + 0.1
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	department_flag = OUTSIDERS
	faction = FACTION_NEUTRAL
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	allowed_races = list(SPEC_ID_OGRE)
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/ogre/avatar
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/outfit/ogre/avatar/pre_equip(mob/living/carbon/human/H)
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
		ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
		H.change_stat(STATKEY_STR, 4)
		H.change_stat(STATKEY_CON, 5)
		H.change_stat(STATKEY_END, 4)
		H.change_stat(STATKEY_INT, -2)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/job/advclass/wretch/ogre/mercenary
	title = "Ogre Mercenary"
	tutorial = "A wandering sell-sword from Gronn. Get paid, get food."
	display_order = JDO_OGRE + 0.2
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	department_flag = OUTSIDERS
	faction = FACTION_NEUTRAL
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	allowed_races = list(SPEC_ID_OGRE)
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/ogre/mercenary
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/outfit/ogre/mercenary/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/armor/plate/ogre
	shirt = /obj/item/clothing/shirt/ogre
	pants = /obj/item/clothing/pants/chainlegs/ogre
	shoes = /obj/item/clothing/shoes/boots/armor/ogre
	gloves = /obj/item/clothing/gloves/plate/ogre
	wrists = /obj/item/clothing/wrists/bracers/ogre
	neck = /obj/item/clothing/neck/gorget/ogre
	head = /obj/item/clothing/head/roguetown/helmet/heavy/ogre
	belt = /obj/item/storage/belt/leather/ogre
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/mace/cudgel/ogre = 1, /obj/item/rope/chain = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/reagent_containers/glass/bottle/waterskin = 1)
	var/weapons = list(
		"Mace" = /obj/item/weapon/mace/goden/steel/ogre,
		"Sword" = /obj/item/weapon/sword/long/greatsword/zwei/ogre,
		"Axe" = /obj/item/weapon/greataxe/steel/doublehead/graggar/ogre
	)
	var/weaponchoice = input(H, "Choose your weapon.", "Weapon Selection") as anything in weapons
	if(weaponchoice)
		r_hand = weapons[weaponchoice]
	if(H)
		ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
		H.change_stat(STATKEY_STR, 4)
		H.change_stat(STATKEY_CON, 3)
		H.change_stat(STATKEY_END, 3)
		H.change_stat(STATKEY_INT, -2)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/job/advclass/wretch/ogre/warlord
	title = "Ogre Warlord"
	tutorial = "A war horn calls you to lead and crush."
	display_order = JDO_OGRE + 0.3
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	department_flag = OUTSIDERS
	faction = FACTION_NEUTRAL
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	allowed_races = list(SPEC_ID_OGRE)
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/ogre/warlord
	give_bank_account = TRUE
	cmode_music = 'sound/music/cmode/towner/CombatInn.ogg'

/datum/outfit/ogre/warlord/pre_equip(mob/living/carbon/human/H)
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
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/mace/cudgel/ogre = 1, /obj/item/rope/chain = 1, /obj/item/flashlight/flare/torch/lantern = 1, /obj/item/reagent_containers/glass/bottle/waterskin = 1)
	var/weapons = list(
		"Mace" = /obj/item/weapon/mace/goden/steel/ogre,
		"Sword" = /obj/item/weapon/sword/long/greatsword/zwei/ogre,
		"Axe" = /obj/item/weapon/greataxe/steel/doublehead/graggar/ogre
	)
	var/weaponchoice = input(H, "Choose your weapon.", "Weapon Selection") as anything in weapons
	if(weaponchoice)
		r_hand = weapons[weaponchoice]
	if(H)
		ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
		H.change_stat(STATKEY_STR, 3)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_END, 2)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_APPRENTICE, TRUE)

/datum/job/advclass/wretch/ogre/cook
	title = "Cook-Cook"
	tutorial = "A massive cook with an even bigger appetite."
	display_order = JDO_OGRE + 0.4
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	department_flag = OUTSIDERS
	faction = FACTION_NEUTRAL
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE
	allowed_races = list(SPEC_ID_OGRE)
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/ogre/cook
	give_bank_account = TRUE

/datum/outfit/ogre/cook/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/apron/ogre
	shirt = /obj/item/clothing/shirt/ogre
	pants = /obj/item/clothing/pants/tights/ogre
	shoes = /obj/item/clothing/shoes/boots/ogre
	gloves = /obj/item/clothing/gloves/leather/ogre
	head = /obj/item/clothing/head/cookhat/ogre
	belt = /obj/item/storage/belt/leather/ogre
	beltl = /obj/item/weapon/knife/cleaver/ogre
	beltr = /obj/item/cooking/pan
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/food/snacks/fat = 2,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/kitchen/spoon = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1
	)
	if(H)
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_END, 1)
		H.change_stat(STATKEY_SPD, -2)
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, SKILL_LEVEL_JOURNEYMAN, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, SKILL_LEVEL_MASTER, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/tanning, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
		H.adjust_skillrank(/datum/skill/labor/butchering, SKILL_LEVEL_MASTER, TRUE)
