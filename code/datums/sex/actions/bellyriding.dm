/datum/sex_action/bellyriding
	name = "Bellyriding"
	description = "Internal bellyriding interaction."
	continous = FALSE
	stamina_cost = 0.2

/datum/sex_action/bellyriding/proc/has_harness_link(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/component/bellyriding/user_comp = user.GetComponent(/datum/component/bellyriding)
	if(user_comp?.current_victim == target)
		return TRUE
	var/datum/component/bellyriding/target_comp = target.GetComponent(/datum/component/bellyriding)
	if(target_comp?.current_victim == user)
		return TRUE
	return FALSE

/datum/sex_action/bellyriding/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	// Hidden from the main interactions list; use the dedicated tab instead.
	return FALSE

/datum/sex_action/bellyriding/proc/get_session(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return get_sex_session(user, target) || get_sex_session(target, user)

/datum/sex_action/bellyriding/groin_rub
	name = "Bellyriding Groin Rub"

/datum/sex_action/bellyriding/groin_rub/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(!has_harness_link(user, target))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/bellyriding/groin_rub/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_session(user, target)
	if(!sex_session)
		return

	user.visible_message(
		sex_session.spanify_force("[user] grinds [user.p_their()] cock along [target]'s belly."),
		sex_session.spanify_force("You grind your cock along [target]'s belly."),
		ignored_mobs = list(target)
	)
	to_chat(target, sex_session.spanify_force("[user] grinds [user.p_their()] cock across your belly."))
	do_thrust_animate(user, target, 4, 2)

	sex_session.perform_sex_action(user, 1, 0, TRUE)
	sex_session.perform_sex_action(target, 0.5, 0, FALSE)
	sex_session.handle_passive_ejaculation()

/datum/sex_action/bellyriding/frot
	name = "Bellyriding Frot"

/datum/sex_action/bellyriding/frot/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(!has_harness_link(user, target))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS) || !target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/bellyriding/frot/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_session(user, target)
	if(!sex_session)
		return

	user.visible_message(
		sex_session.spanify_force("[user] frots [user.p_their()] cock against [target]'s while they hang from the harness."),
		sex_session.spanify_force("You frot your cock against [target]'s while they hang from the harness."),
		ignored_mobs = list(target)
	)
	to_chat(target, sex_session.spanify_force("[user]'s shaft grinds against yours while you're strapped in place."))
	do_thrust_animate(user, target, 4, 2)

	sex_session.perform_sex_action(user, 1, 0, TRUE)
	sex_session.perform_sex_action(target, 1, 0, TRUE)
	sex_session.handle_passive_ejaculation()
	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/bellyriding/anal
	name = "Bellyriding Anal"

/datum/sex_action/bellyriding/anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(!has_harness_link(user, target))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS) || !target.getorganslot(ORGAN_SLOT_ANUS))
		return FALSE
	return TRUE

/datum/sex_action/bellyriding/anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_session(user, target)
	if(!sex_session)
		return

	user.visible_message(
		sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] thrusts into [target]'s ass while they dangle from the harness."),
		sex_session.spanify_force("You [sex_session.get_generic_force_adjective()] thrust into [target]'s ass while they dangle from the harness."),
		ignored_mobs = list(target)
	)
	to_chat(target, sex_session.spanify_force("[user]'s cock drives into your ass while the harness holds you still!"))
	do_thrust_animate(user, target, 4, 2)

	sex_session.perform_sex_action(user, 2, 0, TRUE)
	sex_session.perform_sex_action(target, 1.5, 5, FALSE)
	sex_session.handle_passive_ejaculation()
	sex_session.handle_passive_ejaculation(target)

/datum/sex_action/bellyriding/vaginal
	name = "Bellyriding Vaginal"

/datum/sex_action/bellyriding/vaginal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(!has_harness_link(user, target))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS) || !target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/bellyriding/vaginal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_session(user, target)
	if(!sex_session)
		return

	user.visible_message(
		sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] pistons into [target]'s pussy, held tight by the harness."),
		sex_session.spanify_force("You [sex_session.get_generic_force_adjective()] piston into [target]'s pussy, held tight by the harness."),
		ignored_mobs = list(target)
	)
	to_chat(target, sex_session.spanify_force("[user]'s cock pounds into your pussy while the harness keeps you in place!"))
	do_thrust_animate(user, target, 4, 2)

	sex_session.perform_sex_action(user, 2, 0, TRUE)
	sex_session.perform_sex_action(target, 1.5, 2, FALSE)
	sex_session.handle_passive_ejaculation()
	sex_session.handle_passive_ejaculation(target)
