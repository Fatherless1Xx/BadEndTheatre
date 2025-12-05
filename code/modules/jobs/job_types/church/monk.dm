/datum/job/monk
	title = "Acolyte"
	tutorial = "Chores, exercise, prayer... and more chores. \
	You are a humble acolyte at the temple in Vanderlin, \
	not yet a trained guardian or an ordained priest. \
	But who else would keep the fires lit and the floors clean?"
	department_flag = CHURCHMEN
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_MONK
	faction = FACTION_TOWN
	total_positions = 4
	spawn_positions = 4
	min_pq = -10
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_NONHERETICAL
	allowed_patrons = ALL_TEMPLE_PATRONS

	outfit = /datum/outfit/monk
	give_bank_account = TRUE
	allowed_patrons = ALL_TEMPLE_PATRONS
	job_bitflag = BITFLAG_CHURCH

/datum/outfit/monk
	name = "Acolyte"

/datum/outfit/monk/pre_equip(mob/living/carbon/human/H)
	..()
	H.virginity = TRUE
	ADD_TRAIT(H, TRAIT_RITUALIST, JOB_TRAIT)
	belt = /obj/item/storage/belt/leather/rope
	beltr = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/key/church
	backl = /obj/item/weapon/polearm/woodstaff/quarterstaff
	backpack_contents = list(/obj/item/needle)
	head = /obj/item/clothing/head/roguehood/colored/random
	neck = /obj/item/clothing/neck/psycross/silver
	shoes = /obj/item/clothing/shoes/boots
	armor = /obj/item/clothing/shirt/robe/colored/plain


	var/language = pickweight(list("Dwarvish" = 1, "Elvish" = 1, "Hellspeak" = 1, "Zaladin" = 1, "Orcish" = 1,))
	switch(language)
		if("Dwarvish")
			H.grant_language(/datum/language/dwarvish)
			to_chat(H,span_info("\
			I learned the tongue of the mountain dwellers.")
			)
		if("Elvish")
			H.grant_language(/datum/language/elvish)
			to_chat(H,span_info("\
			I learned the tongue of the primordial race.")
			)
		if("Hellspeak")
			H.grant_language(/datum/language/hellspeak)
			to_chat(H,span_info("\
			I learned the tongue of the hellspawn.")
			)
		if("Zaladin")
			H.grant_language(/datum/language/zalad)
			to_chat(H,span_info("\
			I learned the tongue of Zaladin.")
			)
		if("Orcish")
			H.grant_language(/datum/language/orcish)
			to_chat(H,span_info("\
			I learned the tongue of the Orcs in my time.")
			)


	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE) // They get this and a wooden staff to defend themselves
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/holy, 1, TRUE)
	H.change_stat(STATKEY_INT, 1)
	H.change_stat(STATKEY_END, 2) // For casting lots of spells, and working long hours without sleep at the church
	H.change_stat(STATKEY_PER, -1)
	if(!H.has_language(/datum/language/celestial)) // For discussing church matters with the other Clergy
		H.grant_language(/datum/language/celestial)
		to_chat(H, "<span class='info'>I can speak Celestial with ,c before my speech.</span>")

	var/holder = H.patron.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(H)
