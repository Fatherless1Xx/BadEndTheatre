/obj/structure/ritualcircle
	name = "ritual circle"
	desc = ""
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "ritual_base"
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/allow_dreamwalkers = FALSE

/obj/structure/ritualcircle/attack_hand(mob/living/user)
	if(!allow_dreamwalkers && HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user, span_danger("Only the rune of stirring calls to me now..."))
		return FALSE
	to_chat(user, span_notice("The rune hums faintly, but nothing happens."))
	return TRUE

// Allow wiping runes away.
/obj/structure/ritualcircle/attackby(obj/item/I, mob/living/user, params)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.visible_message(span_warning("[H] begins wiping away the rune"))
		if(do_after(H, 15))
			playsound(loc, 'sound/foley/cloth_wipe (1).ogg', 100, TRUE)
			qdel(src)
			return TRUE
	return ..()

// Simple rune types for placement and sprites.
/obj/structure/ritualcircle/astrata
	name = "Rune of the Sun"
	icon_state = "astrata_chalky"
	desc = "A Holy Rune of Astrata."
	var/solarrites = list("Guiding Light")

/obj/structure/ritualcircle/astrata/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/astrata)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of the Sun", src) as null|anything in solarrites
	if(riteselection == "Guiding Light")
		if(do_after(user, 50))
			user.say("I beseech the Absolute Order, the Sun and Dae!!")
			if(do_after(user, 50))
				user.say("To bring Order to a world of naught!!")
				if(do_after(user, 50))
					user.say("Place your gaze upon me, oh Radiant one!!")
					to_chat(user,span_danger("You feel the eye of Astrata turned upon you. Her warmth dances upon your cheek. You feel yourself warming up..."))
					icon_state = "astrata_active"
					loc.visible_message(span_warning("[user] bursts to flames! Embraced by Her Warmth wholly!"))
					playsound(loc, 'sound/combat/hits/burn (1).ogg', 100, FALSE, -1)
					user.adjust_fire_stacks(10)
					user.flash_fullscreen("redflash3")
					user.emote("firescream")
					guidinglight(src)
					user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
					spawn(120)
						icon_state = "astrata_chalky"

/obj/structure/ritualcircle/astrata/proc/guidinglight(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/guidinglight)
		to_chat(target,span_cultsmall("Astrata's light guides me forward, drawn to me by the Ritualist's pyre!"))
		playsound(target, 'sound/magic/holyshield.ogg', 80, FALSE, -1)

/obj/structure/ritualcircle/noc
	name = "Rune of the Moon"
	icon_state = "noc_chalky"
	desc = "A Holy Rune of Noc. Moonlight shines upon thee."
	var/lunarrites = list("Moonlight Dance")

/obj/structure/ritualcircle/noc/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/noc)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of the Moon", src) as null|anything in lunarrites
	switch(riteselection)
		if("Moonlight Dance")
			if(do_after(user, 50))
				user.say("I beseech the Father of Secrets, the Moon and Night!!")
				if(do_after(user, 50))
					user.say("To bring Wisdom to a world of naught!!")
					if(do_after(user, 50))
						user.say("Place your gaze upon me, oh wise one!!")
						to_chat(user,span_cultsmall("The Moon God's gaze falls upon you. With some effort, it can be drawn upon supplicants."))
						playsound(loc, 'sound/magic/holyshield.ogg', 80, FALSE, -1)
						moonlightdance(src)
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)

/obj/structure/ritualcircle/noc/proc/moonlightdance(src)
	var/ritualtargets = view(7, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/moonlightdance)

/obj/structure/ritualcircle/dendor
	name = "Rune of Beasts"
	icon_state = "dendor_chalky"
	desc = "A Holy Rune of Dendor. Becoming one with nature is to connect with ones true instinct."
	var/bestialrites = list("Rite of the Lesser Wolf")

/obj/structure/ritualcircle/dendor/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/dendor)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Beasts", src) as null|anything in bestialrites
	switch(riteselection)
		if("Rite of the Lesser Wolf")
			if(do_after(user, 50))
				user.say("RRRGH GRRRHHHG GRRRRRHH!!")
				playsound(loc, 'sound/vo/mobs/vw/idle (1).ogg', 100, FALSE, -1)
				if(do_after(user, 50))
					user.say("GRRRR GRRRRHHHH!!")
					playsound(loc, 'sound/vo/mobs/vw/idle (4).ogg', 100, FALSE, -1)
					if(do_after(user, 50))
						loc.visible_message(span_warning("[user] snaps and snarls at the rune. Drool runs down their lip..."))
						playsound(loc, 'sound/vo/mobs/vw/bark (1).ogg', 100, FALSE, -1)
						if(do_after(user, 30))
							icon_state = "dendor_active"
							loc.visible_message(span_warning("[user] snaps their head upward, they let out a howl!"))
							playsound(loc, 'sound/vo/mobs/wwolf/howl (2).ogg', 100, FALSE, -1)
							lesserwolf(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "dendor_chalky"

/obj/structure/ritualcircle/dendor/proc/lesserwolf(src)
	var/ritualtargets = view(1, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		target.apply_status_effect(/datum/status_effect/buff/lesserwolf)

/obj/structure/ritualcircle/malum
	name = "Rune of Forge"
	icon_state = "malum_chalky"
	desc = "A Holy Rune of Malum. A hammer and heat, to fix any imperfections with."
	var/forgerites = list("Ritual of Blessed Reforgance")

/obj/structure/ritualcircle/malum/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/malum)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Creation", src) as null|anything in forgerites
	switch(riteselection)
		if("Ritual of Blessed Reforgance")
			if(do_after(user, 50))
				user.say("God of craft and heat of the forge!!")
				if(do_after(user, 50))
					user.say("Take forth these metals and rebirth them in your furnaces!")
					if(do_after(user, 50))
						user.say("Grant unto me the metals in which to forge great works!")
						to_chat(user,span_danger("You feel a sudden heat rising within you, burning within your chest.."))
						if(do_after(user, 30))
							icon_state = "malum_active"
							user.say("From your forge, may these creations be remade!!")
							loc.visible_message(span_warning("A wave of heat rushes out from the ritual circle before [user]. The metal is reforged in a flash of light!"))
							playsound(loc, 'sound/magic/churn.ogg', 100, FALSE, -1)
							holyreforge(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "malum_chalky"

/obj/structure/ritualcircle/malum/proc/holyreforge(src)
	for(var/mob/living/carbon/human/target in view(7, loc))
		target.flash_fullscreen("whiteflash")
	for(var/obj/item/ingot/silver/I in loc)
		qdel(I)
		new /obj/item/ingot/silverblessed(loc)
	for(var/obj/item/ingot/steel/I in loc)
		qdel(I)
		new /obj/item/ingot/steelholy(loc)

/obj/structure/ritualcircle/xylix
	name = "Rune of Trickery"
	icon_state = "xylix_chalky"
	desc = "A Holy Rune of Xylix."

/obj/structure/ritualcircle/necra
	name = "Rune of Death"
	icon_state = "necra_chalky"
	desc = "A Holy Rune of Necra."

/obj/structure/ritualcircle/pestra
	name = "Rune of Plague"
	icon_state = "pestra_chalky"
	desc = "A Holy Rune of Pestra."
	var/plaguerites = list("Flylord's Triage")

/obj/structure/ritualcircle/pestra/attack_hand(mob/living/user)
	if(!..())
		return
	if((user.patron?.type) != /datum/patron/divine/pestra)
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return
	var/riteselection = input(user, "Rituals of Plague", src) as null|anything in plaguerites
	switch(riteselection)
		if("Flylord's Triage")
			if(do_after(user, 50))
				user.say("Buboes, phlegm, blood and guts!!")
				if(do_after(user, 50))
					user.say("Boils, bogeys, rots and pus!!")
					if(do_after(user, 50))
						user.say("Blisters, fevers, weeping sores!!")
						to_chat(user,span_danger("You feel something crawling up your throat, humming and scratching..."))
						if(do_after(user, 30))
							icon_state = "pestra_active"
							user.say("From your wounds, the fester pours!!")
							to_chat(user,span_cultsmall("My devotion to the Plague Queen allowing, her servants crawl up from my throat. Come now, father fly..."))
							loc.visible_message(span_warning("[user] opens their mouth, disgorging a great swarm of flies!"))
							playsound(loc, 'sound/misc/fliesloop.ogg', 100, FALSE, -1)
							flylordstriage(src)
							user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
							spawn(120)
								icon_state = "pestra_chalky"

/obj/structure/ritualcircle/pestra/proc/flylordstriage(src)
	var/ritualtargets = view(0, loc)
	for(var/mob/living/carbon/human/target in ritualtargets)
		to_chat(target,span_userdanger("You feel them crawling into your wounds and pores. Their horrific hum rings through your ears as they do their work!"))
		target.flash_fullscreen("redflash3")
		target.emote("agony")
		target.Stun(200)
		target.Knockdown(200)
		to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
		target.apply_status_effect(/datum/status_effect/buff/flylordstriage)

/obj/structure/ritualcircle/eora
	name = "Rune of Love"
	icon_state = "eora_chalky"
	desc = "A Holy Rune of Eora."

/obj/structure/ritualcircle/ravox
	name = "Rune of Justice"
	icon_state = "ravox_chalky"
	desc = "A Holy Rune of Ravox."

/obj/structure/ritualcircle/abyssor
	name = "Rune of Storm"
	icon_state = "abyssor_chalky"
	desc = "A Holy Rune of Abyssor."

/obj/structure/ritualcircle/abyssor_alt
	name = "Rune of Stirring"
	icon_state = "abyssoralt_active"
	desc = "A Holy Rune of Abyssor. Something observes."

/obj/structure/ritualcircle/abyssor_alt_inactive
	name = "Rune of Stirring"
	icon_state = "abyssoralt_chalky"
	desc = "A Holy Rune of Abyssor. This one seems different to the rest."
	allow_dreamwalkers = TRUE
	var/stirringrites = list("Rite of the Crystal Spire")
	var/list/dreamwalker_rites = list("Rite of Dreamcraft")

/obj/structure/ritualcircle/abyssor_alt_inactive/attack_hand(mob/living/user)
	if(!..())
		return
	// Allow both Abyssorites and Dreamwalkers to use the rune
	if((user.patron?.type) != /datum/patron/divine/abyssor && !HAS_TRAIT(user, TRAIT_DREAMWALKER))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(!HAS_TRAIT(user, TRAIT_RITUALIST))
		to_chat(user,span_smallred("I don't know the proper rites for this..."))
		return
	if(user.has_status_effect(/datum/status_effect/debuff/ritesexpended))
		to_chat(user,span_smallred("I have performed enough rituals for the day... I must rest before communing more."))
		return

	var/list/available_rites = list()

	if(user.patron?.type == /datum/patron/divine/abyssor)
		available_rites += stirringrites

	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		available_rites += dreamwalker_rites

	if(!length(available_rites))
		to_chat(user,span_smallred("No rites are currently available."))
		return

	var/riteselection = input(user, "Rites of his dream", src) as null|anything in available_rites
	switch(riteselection)
		if("Rite of the Crystal Spire")
			if(do_after(user, 50))
				user.say("Deep Father, hear my call!")
				if(do_after(user, 50))
					user.say("From the Abyss, split the earth!")
					if(do_after(user, 50))
						icon_state = "abyssoralt_active"
						user.say("Let your tempest chase away the craven ones!")
						to_chat(user, span_cultsmall("A crystalline shard forms at the center of the rune, humming with Abyssor's power."))
						user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
						spawn(240)
							icon_state = "abyssoralt_chalky"
		if("Rite of Dreamcraft")
			if(!HAS_TRAIT(user, TRAIT_DREAMWALKER))
				return

			var/list/weapon_options = list(
				"Dreamreaver Greataxe" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamaxe"),
				"Harmonious Spear" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamspear"),
				"Oozing Sword" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamsword"),
				"Thunderous Trident" = image(icon = 'icons/roguetown/weapons/64.dmi', icon_state = "dreamtri")
			)

			var/choice = show_radial_menu(user, src, weapon_options, require_near = TRUE, tooltips = TRUE)
			if(!choice)
				return
			if(!do_after(user, 5 SECONDS))
				return
			user.say("DREAM! DREAM! MANIFEST MY VISION!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("DREAM! DREAM! BEND TO MY WILL!!")
			if(!do_after(user, 5 SECONDS))
				return
			user.say("DREAM! DREAM! FORGE MY WEAPON!!")
			if(!do_after(user, 5 SECONDS))
				return

			icon_state = "abyssoralt_active"
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
			dreamarmor(user)
			dreamcraft_weapon(user, choice)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.mind)
					H.mind.special_role = "dreamwalker"
			spawn(240)
				icon_state = "abyssoralt_chalky"

/obj/structure/ritualcircle/abyssor_alt_inactive/proc/dreamcraft_weapon(mob/living/user, choice)
	var/obj/item/new_weapon
	var/datum/skill/skill_to_teach

	switch(choice)
		if("Harmonious Spear")
			new_weapon = new /obj/item/weapon/polearm/spear/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/polearms
		if("Oozing Sword")
			new_weapon = new /obj/item/weapon/sword/long/greatsword/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/swords
		if("Dreamreaver Greataxe")
			new_weapon = new /obj/item/weapon/axe/dreamscape(user.loc)
			skill_to_teach = /datum/skill/combat/axesmaces
		if("Thunderous Trident")
			new_weapon = new /obj/item/weapon/polearm/spear/dreamscape_trident(user.loc)
			skill_to_teach = /datum/skill/combat/polearms

	if(new_weapon)
		user.put_in_hands(new_weapon)
		to_chat(user, span_warning("The dream solidifies into a [choice]!"))

		var/current_skill = user.get_skill_level(skill_to_teach)
		var/current_athletics = user.get_skill_level(/datum/skill/misc/athletics)
		if(current_skill < 4)
			user.adjust_skillrank(skill_to_teach, 4 - current_skill, TRUE)
			to_chat(user, span_notice("Knowledge of [skill_to_teach] floods your mind!"))
		if(current_athletics < 6)
			user.adjust_skillrank(/datum/skill/misc/athletics, 6 - current_athletics, TRUE)
			to_chat(user, span_notice("Your endurance swells!"))
	else
		to_chat(user, span_warning("The dream fails to take shape."))

/obj/structure/ritualcircle/abyssor_alt_inactive/proc/dreamarmor(mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_DREAMWALKER))
		loc.visible_message(span_cult("THE RITE REJECTS ONE WHO DOES NOT BEND THE DREAMS TO THEIR WILL."))
		return
	target.Stun(60)
	target.Knockdown(60)
	to_chat(target, span_userdanger("UNIMAGINABLE PAIN!"))
	target.emote("Agony")
	playsound(loc, 'sound/combat/newstuck.ogg', 50)
	loc.visible_message(span_cult("Ethereal tendrils emerge from the rune, wrapping around [target]'s body. Their form shifts and warps as dream-stuff solidifies into armor."))
	spawn(20)
		playsound(loc, 'sound/combat/hits/onmetal/grille (2).ogg', 50)
		target.equipOutfit(/datum/outfit/job/roguetown/dreamwalker_armorrite)
		spawn(40)
			to_chat(target, span_purple("Reality is but a fragile dream. You are the dreamer, and your will is law."))

/obj/structure/ritualcircle/zizo
	name = "Rune of Progress"
	icon_state = "zizo_chalky"
	desc = "A Holy Rune of ZIZO."

/obj/structure/ritualcircle/matthios
	name = "Rune of Transaction"
	icon_state = "matthios_chalky"
	desc = "A Holy Rune of Matthios."

/obj/structure/ritualcircle/graggar
	name = "Rune of Violence"
	icon_state = "graggar_chalky"
	desc = "A Holy Rune of Graggar."

/obj/structure/ritualcircle/baotha
	name = "Rune of Hedonism"
	icon_state = "baotha_chalky"
	desc = "A Holy Rune of Baotha."

/obj/structure/ritualcircle/psydon
	name = "Rune of Enduring"
	icon_state = "psydon_chalky"
	desc = "A Holy Rune of Psydon."
