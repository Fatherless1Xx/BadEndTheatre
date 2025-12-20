/obj/item/clothing/armor/bellyriding_harness
	name = "bellyriding harness"
	desc = "A reinforced strap harness built to secure a restrained partner against your torso."
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "bellyriding_harness"
	item_state = "bellyriding_harness"
	slot_flags = ITEM_SLOT_ARMOR
	body_parts_covered = CHEST|VITALS
	armor = ARMOR_MINIMAL
	strip_delay = 7 SECONDS

/obj/item/clothing/armor/bellyriding_harness/equipped(mob/user, slot, initial)
	. = ..()
	if(ishuman(loc) && (slot & ITEM_SLOT_ARMOR))
		var/mob/living/carbon/human/wearer = loc
		wearer.AddComponent(/datum/component/bellyriding, src)
	else if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		var/datum/component/bellyriding/comp = wearer.GetComponent(/datum/component/bellyriding)
		if(comp)
			qdel(comp)

/obj/item/clothing/armor/bellyriding_harness/dropped(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/wearer = user
		var/datum/component/bellyriding/comp = wearer.GetComponent(/datum/component/bellyriding)
		if(comp)
			qdel(comp)
