/datum/job/advclass/wretch/lunacyembracer
	title = "Lunacy Embracer"
	tutorial = "You have rejected and terrorized civilization in the name of nature. You run wild under the moon. A terror to townsfolk. A champion of Dendor."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	blacklisted_species = list(/datum/species/harpy)
	min_pq = 30
	outfit = /datum/outfit/wretch/lunacyembracer
	total_positions = 1

/datum/outfit/wretch/lunacyembracer
	name = "Lunacy Embracer"

/datum/outfit/wretch/lunacyembracer/pre_equip(mob/living/carbon/human/H)
	..()

	to_chat(H, span_danger("You have abandoned your humanity to run wild under the moon. The call of nature fills your soul!"))

	ADD_TRAIT(H, TRAIT_NUDIST, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_GOOD_SWIM, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/farming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 2, TRUE)

	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_LCK, 2)
	H.change_stat(STATKEY_INT, -2)
	H.change_stat(STATKEY_PER, -2)

	armor = /obj/item/clothing/suit/roguetown/armor/skin_armor/lunacyembracer_hide
	pants = /obj/item/clothing/pants/lunacyembracer_hide
	head = /obj/item/clothing/head/lunacyembracer_hide

	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			wrists = /obj/item/clothing/neck/psycross/silver/astrata
		if(/datum/patron/divine/necra)
			wrists = /obj/item/clothing/neck/psycross/silver/necra
		if(/datum/patron/divine/eora)
			wrists = /obj/item/clothing/neck/psycross/silver/eora
		if(/datum/patron/divine/noc)
			wrists = /obj/item/clothing/neck/psycross/silver/noc
		if(/datum/patron/divine/pestra)
			wrists = /obj/item/clothing/neck/psycross/silver/pestra
		if(/datum/patron/divine/dendor)
			wrists = /obj/item/clothing/neck/psycross/silver/dendor
		if(/datum/patron/divine/abyssor)
			wrists = /obj/item/clothing/neck/psycross/silver/abyssor
		if(/datum/patron/divine/ravox)
			wrists = /obj/item/clothing/neck/psycross/silver/ravox
		if(/datum/patron/divine/xylix)
			wrists = /obj/item/clothing/neck/psycross/silver/xylix
		if(/datum/patron/divine/malum)
			wrists = /obj/item/clothing/neck/psycross/silver/malum
		else
			wrists = /obj/item/clothing/neck/psycross/silver

	switch(H.patron?.type)
		if(/datum/patron/divine/dendor)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.grant_language(/datum/language/beast)
		if(/datum/patron/divine/noc)
			H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
			H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		if(/datum/patron/divine/abyssor)
			H.adjust_skillrank(/datum/skill/labor/fishing, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		if(/datum/patron/divine/pestra)
			H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/alchemy, 1, TRUE)
		if(/datum/patron/divine/eora)
			ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		if(/datum/patron/divine/malum)
			H.adjust_skillrank(/datum/skill/craft/blacksmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/smelting, 1, TRUE)
		if(/datum/patron/divine/ravox)
			H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		if(/datum/patron/divine/xylix)
			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/music, 1, TRUE)

	var/holder = H.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.grant_to(H)

	wretch_select_bounty(H)

/obj/item/clothing/suit/roguetown/armor/skin_armor/lunacyembracer_hide
	name = "skinward"
	desc = "A ward that hardens when struck."
	icon = null
	mob_overlay_icon = null
	icon_state = null

	resistance_flags = FIRE_PROOF
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)

	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = COVERAGE_FULL

	flags_inv = null
	surgery_cover = FALSE

	max_integrity = 400
	var/repair_amount = 6
	var/repair_time = 20 SECONDS
	var/last_repair = 0

/obj/item/clothing/suit/roguetown/armor/skin_armor/lunacyembracer_hide/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "lunacyembracer_hide")
	addtimer(CALLBACK(src, PROC_REF(regen_tick)), repair_time)

/obj/item/clothing/suit/roguetown/armor/skin_armor/lunacyembracer_hide/proc/regen_tick()
	if(QDELETED(src))
		return

	if(world.time >= last_repair + repair_time)
		last_repair = world.time

		if(hascall(src, "repair_damage"))
			call(src, "repair_damage")(repair_amount)
		else if(hascall(src, "repair_integrity"))
			call(src, "repair_integrity")(repair_amount)

	addtimer(CALLBACK(src, PROC_REF(regen_tick)), repair_time)



/obj/item/clothing/pants/lunacyembracer_hide
	name = "skinward"
	desc = "A ward that hardens when struck."
	icon = null
	mob_overlay_icon = null
	icon_state = null

	resistance_flags = FIRE_PROOF
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)

	slot_flags = ITEM_SLOT_PANTS
	body_parts_covered = 0
	flags_inv = null

	max_integrity = 400
	var/repair_amount = 6
	var/repair_time = 20 SECONDS
	var/last_repair = 0

/obj/item/clothing/pants/lunacyembracer_hide/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "lunacyembracer_hide")
	addtimer(CALLBACK(src, PROC_REF(regen_tick)), repair_time)

/obj/item/clothing/pants/lunacyembracer_hide/proc/regen_tick()
	if(QDELETED(src))
		return

	if(world.time >= last_repair + repair_time)
		last_repair = world.time

		if(hascall(src, "repair_damage"))
			call(src, "repair_damage")(repair_amount)
		else if(hascall(src, "repair_integrity"))
			call(src, "repair_integrity")(repair_amount)

	addtimer(CALLBACK(src, PROC_REF(regen_tick)), repair_time)



/obj/item/clothing/head/lunacyembracer_hide
	name = "skinward"
	desc = "A ward that hardens when struck."
	icon = null
	mob_overlay_icon = null
	icon_state = null

	resistance_flags = FIRE_PROOF
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)

	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = 0
	flags_inv = null

	max_integrity = 400
	var/repair_amount = 6
	var/repair_time = 20 SECONDS
	var/last_repair = 0

/obj/item/clothing/head/lunacyembracer_hide/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "lunacyembracer_hide")
	addtimer(CALLBACK(src, PROC_REF(regen_tick)), repair_time)

/obj/item/clothing/head/lunacyembracer_hide/proc/regen_tick()
	if(QDELETED(src))
		return

	if(world.time >= last_repair + repair_time)
		last_repair = world.time

		if(hascall(src, "repair_damage"))
			call(src, "repair_damage")(repair_amount)
		else if(hascall(src, "repair_integrity"))
			call(src, "repair_integrity")(repair_amount)

	addtimer(CALLBACK(src, PROC_REF(regen_tick)), repair_time)
