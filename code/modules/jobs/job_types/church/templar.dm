/datum/job/templar
	title = "Templar"
	tutorial = "Templars are warriors who have forsaken wealth and station in the service of the church, either from fervent zeal or remorse for past sins.\
	They are vigilant sentinels, guarding priest and altar, steadfast against heresy and shadow-beasts that creep in darkness. \
	But in the quiet of troubled sleep, there is a question left. Does the blood they spill sanctify them, or stain them forever? If service ever demanded it, whose blood would be the price?"
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_TEMPLAR
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	min_pq = 8
	bypass_lastclass = TRUE

// Medicators and Tritons are hallowed in the eyes of the Ten, no matter how much Astrata dislikes it, Harpies do not get to be templars because they literally cannot wear plate armour nor lift their weapons.
	allowed_races = RACES_TEMPLAR


	allowed_patrons = ALL_TEMPLAR_PATRONS

	outfit = /datum/outfit/templar
	give_bank_account = 0

	allowed_patrons = ALL_TEMPLAR_PATRONS
	job_bitflag = BITFLAG_CHURCH

/datum/outfit/templar
	name = "Templar"

/datum/outfit/templar/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/helmet/heavy/necked
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	armor = /obj/item/clothing/armor/brigandine
	shirt = /obj/item/clothing/armor/chainmail //hauberk > haubergeon, requested by Tyger
	pants = /obj/item/clothing/pants/chainlegs
	shoes = /obj/item/clothing/shoes/boots/armor/light
	backl = /obj/item/storage/backpack/satchel
	//neck = /obj/item/clothing/neck/chaincoif //requested by Tyger
	backpack_contents = list(/obj/item/storage/keyring/priest = 1)
	backr = /obj/item/weapon/shield/tower/metal
	belt = /obj/item/storage/belt/leather/black
	beltl = /obj/item/storage/belt/pouch/coins/poor
	ring = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/chain
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, -1)
	ADD_TRAIT(H, TRAIT_RITUALIST, JOB_TRAIT)
	if(!H.has_language(/datum/language/celestial)) // For discussing church matters with the other Clergy
		H.grant_language(/datum/language/celestial)
		to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")
	head = /obj/item/clothing/head/helmet/heavy/necked/abyssor
	armor = /obj/item/clothing/armor/brigandine/abyssor
	wrists = /obj/item/clothing/neck/psycross/silver/abyssor
	cloak = /obj/item/clothing/cloak/stabard/templar/abyssor
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_KNOWBANDITS, TRAIT_GENERIC)

	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(H)
	if(H.dna?.species)
		if(H.dna.species.id == SPEC_ID_HUMEN)
			H.dna.species.soundpack_m = new /datum/voicepack/male/knight()

/datum/outfit/templar/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	var/obj/item/weapon/sword/long/exe/astrata/P = new(get_turf(src))
	H.equip_to_appropriate_slot(P)
