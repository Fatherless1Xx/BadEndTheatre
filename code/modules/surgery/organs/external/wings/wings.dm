/obj/item/organ/wings
	name = "wings"
	desc = "A pair of wings. Those may or may not allow you to fly... or at the very least flap."
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_WINGS

	///Whether a wing can be opened by the *wing emote. The sprite use a "_open" suffix, before their layer
	var/can_open
	///Whether an openable wing is currently opened
	var/is_open

/obj/item/organ/wings/anthro/seelie
	name = "seelie wings"
	w_class = WEIGHT_CLASS_TINY
	accessory_type = /datum/sprite_accessory/wings/seelie/fairy
	dropshrink = 0.35

/obj/item/organ/wings/anthro/seelie/Remove(mob/living/carbon/M, special)
	. = ..()
	// Shrink the dropped wings to a crumpled, delicate bundle
	transform = matrix() * 0.35
	w_class = WEIGHT_CLASS_TINY
	return .

/obj/item/organ/wings/anthro/seelie/attack(mob/living/carbon/M, mob/user)
	if(M == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		// Allow self-reattachment if we're a wingless Seelie
		if(isseelie(H) && !H.getorganslot(ORGAN_SLOT_WINGS))
			return afterattack(H, user, TRUE)
		to_chat(user, span_warning("These wings are too delicate to eat."))
		return TRUE
	return ..()

/obj/item/organ/wings/anthro/seelie/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return ..()
	if(!ishuman(target) || !isseelie(target))
		return ..()
	var/mob/living/carbon/human/H = target
	if(H.getorganslot(ORGAN_SLOT_WINGS))
		to_chat(user, span_warning("[H] already has wings."))
		return TRUE
	if(!do_after(user, 2 SECONDS, target = H))
		return TRUE
	if(H.getorganslot(ORGAN_SLOT_WINGS))
		return TRUE
	Insert(H, TRUE, TRUE)
	transform = initial(transform)
	H.set_body_position(STANDING_UP)
	H.set_resting(FALSE, silent = TRUE)
	if(isseelie(H))
		H.seelie_ensure_scale()
	H.update_body()
	H.visible_message(span_notice("[user] carefully reattaches wings to [H]."), span_notice("My wings are reattached."))
	if(isseelie(H))
		var/datum/species/seelie/S = H.dna?.species
		if(S)
			S.enforce_wing_requirement(H)
	return TRUE
