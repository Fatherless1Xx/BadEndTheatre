// Minimal cursed collar port: wearable, leashable, and locks to the wearer.

/obj/item/clothing/neck/roguetown/cursed_collar
	name = "cursed collar"
	desc = "A sinister-looking collar with ruby studs. It seems to radiate a dark energy."
	icon = 'modular/icons/obj/cursed_collar.dmi'
	mob_overlay_icon = 'modular/icons/mob/cursed_collar.dmi'
	icon_state = "cursed_collar"
	item_state = "cursed_collar"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	resistance_flags = FIRE_PROOF
	leashable = TRUE
	var/datum/mind/collar_master = null

/obj/item/clothing/neck/roguetown/cursed_collar/attack(mob/living/carbon/human/C, mob/living/user)
	if(!istype(C))
		return ..()
	if(C.get_item_by_slot(ITEM_SLOT_NECK))
		to_chat(user, span_warning("[C] is already wearing something around their neck!"))
		return
	if(!user?.mind)
		return
	if(do_after(user, 3 SECONDS, C, (IGNORE_HELD_ITEM)))
		collar_master = user.mind
		var/datum/component/collar_master/CM = user.mind.GetComponent(/datum/component/collar_master) || user.mind.AddComponent(/datum/component/collar_master)
		if(!C.equip_to_slot_if_possible(src, ITEM_SLOT_NECK, TRUE, TRUE))
			to_chat(user, span_warning("I fail to lock the collar around [C]'s neck!"))
			return
		CM?.add_pet(C)
		to_chat(user, span_warning("The collar locks around [C]'s neck."))
		playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)
	return

/obj/item/clothing/neck/roguetown/cursed_collar/attack_self(mob/user)
	. = ..()
	if(!user?.mind)
		return
	var/confirm = alert(user, "Imprint this collar to yourself as master?", "Cursed Collar", "Yes", "No")
	if(confirm != "Yes")
		return
	collar_master = user.mind
	user.mind.GetComponent(/datum/component/collar_master) || user.mind.AddComponent(/datum/component/collar_master)
	to_chat(user, span_userdanger("You feel the collar being imprinted with your will."))

/obj/item/clothing/neck/roguetown/cursed_collar/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_NECK)
		return
	ADD_TRAIT(src, TRAIT_NODROP, "cursed_collar")
	if(collar_master)
		var/datum/component/collar_master/CM = collar_master.GetComponent(/datum/component/collar_master) || collar_master.AddComponent(/datum/component/collar_master)
		CM?.add_pet(user)

/obj/item/clothing/neck/roguetown/cursed_collar/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(src, TRAIT_NODROP, "cursed_collar")
	if(user && collar_master)
		var/datum/component/collar_master/CM = collar_master.GetComponent(/datum/component/collar_master)
		CM?.remove_pet(user)

/obj/item/clothing/neck/roguetown/cursed_collar/Destroy()
	REMOVE_TRAIT(src, TRAIT_NODROP, "cursed_collar")
	return ..()
