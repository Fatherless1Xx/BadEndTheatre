/datum/job/advclass/mercenary/bogwalker
	title = "Bogwalker"
	tutorial = "You've spent your years wandering the bogs of Psydonia, eking out a living a hunter of both men and beast. \
	Your axe has claimed many a head and the bog has hardened your body and mind against all threats."
	allowed_races = list(SPEC_ID_HALF_ORC)
	outfit = /datum/outfit/mercenary/bogwalker
	category_tags = list(CTAG_MERCENARY)

	total_positions = 2
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/outfit/mercenary/bogwalker
	head = /obj/item/clothing/head/helmet/kettle
	armor = /obj/item/clothing/armor/leather/hide
	shirt = /obj/item/clothing/shirt/tunic/colored/green
	gloves = /obj/item/clothing/gloves/leather
	belt = /obj/item/storage/belt/leather/mercenary
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/weapon/knife/villager
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/polearm/halberd/bardiche/woodcutter
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor)

/datum/outfit/mercenary/bogwalker/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, pick(0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 3, TRUE)

	H.merctype = 9

	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_INT, -2)

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NASTY_EATER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
