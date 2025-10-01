/datum/job/advclass/mercenary/porter
	title = "Porter"
	tutorial = "You are a jack-of-all-trades from the dank depth of subterra, You've survived by being useful. Whether it's carrying someone's burdens, mending their gears, stitching wounds, or even cooking a surprisingly edible meal, For a price, of course."
	allowed_races = list(SPEC_ID_KOBOLD)
	outfit = /datum/outfit/mercenary/porter
	category_tags = list(CTAG_MERCENARY)
	total_positions = 1
	cmode_music = 'sound/music/cmode/Combat_Weird.ogg'

/datum/outfit/mercenary/porter/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/articap/porter
	armor = /obj/item/clothing/armor/leather/jacket/artijacket/porter
	pants = /obj/item/clothing/pants/trou
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	shoes = /obj/item/clothing/shoes/boots/leather
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/storage/messkit
	beltl = /obj/item/weapon/knife/cleaver
	mask = /obj/item/clothing/face/goggles
	backr = /obj/item/fishingrod/fisher
	backl = /obj/item/storage/backpack/backpack/artibackpack/porter //+1 to Row/Columns compared to a regular backpack alongside preserving foods.
	backpack_contents = list(/obj/item/kitchen/rollingpin = 1, /obj/item/storage/belt/pouch/coins/poor, /obj/item/weapon/knife/hunting, /obj/item/weapon/hammer/iron = 1, /obj/item/weapon/shovel/small = 1, /obj/item/recipe_book/survival = 1, /obj/item/recipe_book/cooking = 1, /obj/item/key/mercenary = 1, /obj/item/reagent_containers/glass/bucket/pot = 1)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE) //To get out of grasps, slippery bastard
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 2, TRUE)
	//Can't expect those kobolds to not be thieves or assist with such things.
	H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
	//Jack of All Trade, Master of None.
	H.adjust_skillrank(/datum/skill/misc/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/bombs, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
	H.merctype = 9
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_END, 3)
	H.change_stat(STATKEY_INT, 4) //Unique specimen, They learned many things, it basically nullify and give a bonus of +2 to their INT.
	H.change_stat(STATKEY_SPD, 2) //Gee, Why do this kobold get more stats than everyone else? the answer is because they have to at the very least escape from being killed and looted.
	H.change_stat(STATKEY_PER, -2) //-4 PER with a chance of it being a -5 hit hard
	ADD_TRAIT(H, TRAIT_AMAZING_BACK, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MIRACULOUS_FORAGING, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
