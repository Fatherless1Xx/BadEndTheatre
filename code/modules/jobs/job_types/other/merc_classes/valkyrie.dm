/datum/job/advclass/mercenary/valkyrie
	title = "Valkyrie"
	tutorial = "You've seen countless battles and earned your fair share of riches from them. \
	Flying above the battlefield, you seek those who are injured and come to their aid, for a price."
	allowed_races = list(SPEC_ID_HARPY)

	outfit = /datum/outfit/mercenary/valkyrie
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

/datum/outfit/mercenary/valkyrie
	head = /obj/item/clothing/head/roguehood/colored/red
	mask = /obj/item/clothing/face/shepherd/rag
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	backl = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/leather
	shirt = /obj/item/clothing/armor/gambeson/light
	gloves = /obj/item/clothing/gloves/leather
	cloak = /obj/item/clothing/cloak/raincloak/colored/red
	belt = /obj/item/storage/belt/leather/mercenary
	beltr = /obj/item/weapon/sword
	beltl = /obj/item/reagent_containers/glass/bottle/stronghealthpot

	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid, /obj/item/reagent_containers/glass/bottle/healthpot = 3, /obj/item/weapon/knife/hunting)

/datum/outfit/mercenary/valkyrie/pre_equip(mob/living/carbon/human/H)
	..()

	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, pick(2,3), TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)

	H.merctype = 9

	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_SPD, 3) // It's the only thing they've got

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
