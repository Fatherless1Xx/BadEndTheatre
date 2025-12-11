/datum/sex_action/sex
	stored_item_type = /obj/item/organ/genitals/penis
	stored_item_name = "penetrating member"
	requires_hole_storage = TRUE
	abstract_type = /datum/sex_action/sex
	knot_on_finish = TRUE
	can_knot = TRUE
	user_priority = 100
	target_priority = 0

/datum/sex_action/sex/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	// Seelies cannot penetrate non-seelies
	if(isseelie(user) && !isseelie(target))
		to_chat(user, span_warning("I'm far too small to penetrate them; I should stick to rubbing or stroking."))
		return FALSE
	// Non-seelies get a warning before trying to penetrate a seelie
	if(!isseelie(user) && isseelie(target))
		if(user?.client)
			var/choice = alert(user, "This won't fit and will likely injure the seelie. Continue anyway?", "Tiny target", "No", "Yes")
			if(choice != "Yes")
				return FALSE
	return TRUE

/datum/sex_action/sex/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(user, ORGAN_SLOT_PENIS)

/datum/sex_action/sex/proc/apply_penetration_side_effects(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!isseelie(target) || isseelie(user))
		return
	// Hurts the seelie each thrust
	target.apply_damage(8, BRUTE, BODY_ZONE_PRECISE_GROIN)
	target.visible_message(
		span_danger("[target] winces in pain from the strain!"),
		span_userdanger("Agony shoots through me; they're far too big!")
	)
