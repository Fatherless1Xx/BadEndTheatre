/datum/job/advclass/mercenary/expegasusknight
	title = "Ex-Pegasus Knight"
	tutorial = "A former pegasus knight hailing from the southern Elven nation of Lakkari. Once a graceful warrior that ruled the skies, now a traveling sellsword that rules the streets, doing Faience's dirtiest work."
	allowed_races = RACES_PLAYER_ELF
	outfit = /datum/outfit/mercenary/expegasusknight
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

/datum/outfit/mercenary/expegasusknight/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/ridingboots
	cloak = /obj/item/clothing/cloak/pegasusknight
	head = /obj/item/clothing/head/helmet/pegasusknight
	gloves = /obj/item/clothing/gloves/angle
	wrists = /obj/item/clothing/wrists/bracers/leather
	belt = /obj/item/storage/belt/leather/mercenary/black
	armor = /obj/item/clothing/armor/gambeson
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/shield/tower/buckleriron
	beltr= /obj/item/weapon/sword/long/shotel
	beltl = /obj/item/weapon/knife/njora/steel
	shirt = /obj/item/clothing/armor/chainmail/iron
	pants = /obj/item/clothing/pants/trou/leather
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)

	H.merctype = 11

	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_SPD, 2)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
