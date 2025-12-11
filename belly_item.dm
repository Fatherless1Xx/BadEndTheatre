/obj/item/clothing/suit/bellyriding_harness
	name = "dual harness"
	desc = "LustWish-brand harness, suitable for fastening one person under or beneath another. \
			Manufactured in a \"one-size-fits-all\" configuration for bipedals and taurs alike. \
			In recent times, these have come into fashion with EROS-sector security forces for \"alternative\" forms of punishment or coercion."

	icon = 'icons/roguetown/clothing/armor.dmi'
	icon_state = "bellyriding_harness"
	worn_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	worn_icon_state = "bellyriding_harness"
	slot_flags = ITEM_SLOT_ARMOR

/obj/item/clothing/suit/bellyriding_harness/equipped(mob/user, slot, initial)
	. = ..()
	if(ishuman(loc) && (slot & ITEM_SLOT_ARMOR))
		var/mob/living/carbon/human/wearer = loc
		wearer.AddComponent(/datum/component/bellyriding, src)
		strip_delay = 7 SECONDS
	else
		if(ishuman(loc))
			var/mob/living/carbon/human/wearer = loc
			var/datum/component/bellyriding/comp = wearer.GetComponent(/datum/component/bellyriding)
			if(comp)
				qdel(comp)
		strip_delay = initial(strip_delay)

/obj/item/clothing/suit/bellyriding_harness/dropped(mob/user, silent)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/wearer = user
		var/datum/component/bellyriding/comp = wearer.GetComponent(/datum/component/bellyriding)
		if(comp)
			qdel(comp)
