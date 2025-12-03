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

/obj/structure/ritualcircle/noc
	name = "Rune of the Moon"
	icon_state = "noc_chalky"
	desc = "A Holy Rune of Noc."

/obj/structure/ritualcircle/dendor
	name = "Rune of Beasts"
	icon_state = "dendor_chalky"
	desc = "A Holy Rune of Dendor."

/obj/structure/ritualcircle/malum
	name = "Rune of Forge"
	icon_state = "malum_chalky"
	desc = "A Holy Rune of Malum."

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
