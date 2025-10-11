/datum/job/advclass/pilgrim/peasant
	title = "Peasant"
	tutorial = "A serf with no particular proficiency of their own, born poor \
				and more likely to die poor. Farm workers, carriers, handymen."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/adventurer/peasant
	category_tags = list(CTAG_PILGRIM)
	apprentice_name = "Handyman"
	cmode_music = 'sound/music/cmode/towner/CombatBeggar.ogg' // pilgrims aren't towners, this fits them more for a combat on the woods

/datum/outfit/adventurer/peasant/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, rand(2,3), TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/taming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	belt = /obj/item/storage/belt/leather/rope
	shirt = pick(/obj/item/clothing/shirt/undershirt/colored/random, /obj/item/clothing/shirt/shortshirt/colored/random)
	pants = /obj/item/clothing/pants/trou
	head = pick(/obj/item/clothing/head/strawhat, /obj/item/clothing/head/armingcap, /obj/item/clothing/head/headband/colored/red, /obj/item/clothing/head/roguehood/colored/random)
	shoes = pick(/obj/item/clothing/shoes/simpleshoes, /obj/item/clothing/shoes/boots/leather)
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/weapon/hoe
	backl = /obj/item/storage/backpack/satchel
	neck = /obj/item/storage/belt/pouch/coins/poor
	armor = /obj/item/clothing/armor/gambeson/light/striped
	beltl = /obj/item/weapon/sickle
	beltr = /obj/item/weapon/flail/towner // the peasant is a walking workshop at this point but this flail is their key to portable threshing without sacrifice the pitchfork or hoe
	var/obj/item/weapon/pitchfork/P = new()
	H.put_in_hands(P, forced = TRUE)
	if(H.gender == FEMALE)
		head = /obj/item/clothing/head/armingcap
		armor = /obj/item/clothing/shirt/dress/gen/colored/random
		shirt = /obj/item/clothing/shirt/undershirt
		pants = null
	backpack_contents = list(/obj/item/flint, /obj/item/neuFarm/seed/wheat=1,/obj/item/neuFarm/seed/apple=1,/obj/item/fertilizer/ash=1,/obj/item/weapon/knife/villager=1, /obj/item/weapon/shovel/small)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_INT, -1)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)	//Peasants probably smell terrible. (:
	ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
