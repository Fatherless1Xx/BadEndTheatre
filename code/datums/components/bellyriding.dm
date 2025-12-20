/datum/component/bellyriding
	/// Who is currently attached to us?
	var/mob/living/carbon/human/current_victim = null
	/// How many steps until we try another interaction tick.
	var/steps_until_interaction = 4
	/// Last action we successfully ran, used to bias repeats that are still valid.
	var/last_action_type
	/// Is our ability to do interactions enabled?
	var/enable_interactions = TRUE
	/// Our tied ability.
	var/datum/action/innate/toggle_bellyriding_heehee_pp/stored_action = new

	// Stored visuals for the current victim so we can restore them.
	var/old_victim_layer

	// Stored state so we can restore the wearer after we finish buckling.
	var/old_can_buckle
	var/old_buckle_requires_restraints
	var/old_max_buckled_mobs

/datum/component/bellyriding/Initialize(atom/movable/buckle_relay)
	if(!ishuman(parent) || !istype(buckle_relay))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(on_mousedropped_onto))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_step))
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(update_visuals))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(parent, COMSIG_MOVABLE_UNBUCKLE, PROC_REF(on_any_unbuckle))

/datum/component/bellyriding/Destroy(force)
	unbuckle_victim()
	QDEL_NULL(stored_action)
	return ..()

/datum/component/bellyriding/proc/on_mousedropped_onto(datum/_source, atom/movable/dropped, mob/user)
	SIGNAL_HANDLER
	if(!ishuman(dropped))
		return

	try_buckle_victim(dropped, user)

/datum/component/bellyriding/proc/on_attack_hand(datum/_source, mob/living/user)
	SIGNAL_HANDLER

	if(!current_victim)
		return

	return try_unbuckle_victim(user)

/datum/component/bellyriding/proc/on_step(datum/_source, old_loc, movement_dir, forced, ...)
	SIGNAL_HANDLER

	if(!current_victim)
		return

	steps_until_interaction -= 1
	if(steps_until_interaction <= 0)
		steps_until_interaction = initial(steps_until_interaction)
		addtimer(CALLBACK(src, PROC_REF(maybe_do_interaction)), 0)
	update_visuals()

/datum/component/bellyriding/proc/try_buckle_victim(mob/living/carbon/human/victim, mob/user)
	set waitfor = FALSE

	var/mob/living/carbon/human/wearer = parent
	if(!istype(wearer) || !istype(victim) || DOING_INTERACTION_WITH_TARGET(user, wearer))
		return
	if(current_victim)
		to_chat(user, span_warning("There's already someone strapped to the harness."))
		return
	if(!victim.handcuffed || !victim.legcuffed)
		to_chat(user, span_warning("[victim] needs to be both handcuffed and legcuffed first!"))
		return
	if(victim.mob_size > wearer.mob_size)
		to_chat(user, span_warning("[victim] is too large for you to strap down like this!"))
		return

	store_old_state(victim)
	if(!can_buckle(victim, user))
		restore_old_state(victim)
		return

	var/torturer_message = span_warning("You start fastening [victim] to your harness...")
	var/victim_message = span_warning("[wearer] starts fastening you to [wearer.p_their()] harness!")
	var/observer_message = span_warning("[wearer] starts fastening [victim] to [wearer.p_their()] harness!")

	user.visible_message(observer_message, torturer_message, ignored_mobs = list(victim))
	to_chat(victim, victim_message)

	if(!do_after(user, 3 SECONDS, victim) || !can_buckle(victim, user))
		restore_old_state(victim)
		return

	if(!wearer.buckle_mob(victim, TRUE, TRUE))
		restore_old_state(victim)
		return

	if(victim.buckled != wearer)
		restore_old_state(victim)
		return

	stored_action.Grant(wearer)
	wearer.add_movespeed_modifier(MOVESPEED_ID_BELLYRIDE, multiplicative_slowdown = 0.8)
	current_victim = victim
	RegisterSignal(current_victim, COMSIG_PARENT_QDELETING, PROC_REF(on_victim_deleted))
	update_visuals()

/datum/component/bellyriding/proc/try_unbuckle_victim(mob/living/carbon/human/user)
	set waitfor = FALSE

	if(!current_victim || DOING_INTERACTION_WITH_TARGET(user, parent))
		return

	. = COMPONENT_CANCEL_ATTACK_CHAIN

	var/mob/living/carbon/human/wearer = parent

	var/torturer_message = span_warning("You begin unfastening [current_victim] from your harness...")
	var/victim_message = span_warning("[wearer] starts unfastening you from [wearer.p_their()] harness.")
	var/observer_message = span_warning("[wearer] starts unfastening [current_victim] from [wearer.p_their()] harness.")

	user.visible_message(observer_message, torturer_message, ignored_mobs = list(current_victim))
	to_chat(current_victim, victim_message)

	if(!do_after(user, 3 SECONDS, current_victim))
		return

	unbuckle_victim()

/datum/component/bellyriding/proc/unbuckle_victim(skip_unbuckle = FALSE)
	if(!current_victim)
		return

	var/mob/living/carbon/human/wearer = parent
	var/mob/living/carbon/human/victim = current_victim
	current_victim = null
	last_action_type = null

	if(!skip_unbuckle && victim && victim.buckled == wearer)
		wearer.unbuckle_mob(victim, TRUE)

	restore_old_state(victim)
	wearer.remove_movespeed_modifier(MOVESPEED_ID_BELLYRIDE)
	stored_action.Remove(wearer)

	if(victim && !QDELETED(victim))
		victim.reset_offsets("bellyride")
		UnregisterSignal(victim, COMSIG_PARENT_QDELETING)
		victim.Knockdown(0.1 SECONDS, TRUE)

/datum/component/bellyriding/proc/store_old_state(mob/living/carbon/human/victim)
	var/mob/living/carbon/human/wearer = parent
	old_can_buckle = wearer.can_buckle
	old_buckle_requires_restraints = wearer.buckle_requires_restraints
	old_max_buckled_mobs = wearer.max_buckled_mobs
	wearer.can_buckle = TRUE
	wearer.buckle_requires_restraints = TRUE
	wearer.max_buckled_mobs = max(wearer.max_buckled_mobs + 1, 1)
	if(victim)
		old_victim_layer = victim.layer

/datum/component/bellyriding/proc/restore_old_state(mob/living/carbon/human/victim)
	var/mob/living/carbon/human/wearer = parent
	wearer.can_buckle = old_can_buckle
	wearer.buckle_requires_restraints = old_buckle_requires_restraints
	if(!isnull(old_max_buckled_mobs))
		wearer.max_buckled_mobs = old_max_buckled_mobs
	old_max_buckled_mobs = null
	if(victim)
		if(!isnull(old_victim_layer))
			victim.layer = old_victim_layer
	old_victim_layer = null

/datum/component/bellyriding/proc/can_buckle(mob/living/carbon/human/victim, mob/user)
	var/mob/living/carbon/human/wearer = parent
	if(!istype(victim) || DOING_INTERACTION_WITH_TARGET(user, wearer))
		return FALSE

	if(current_victim)
		to_chat(user, span_warning("There's already someone strapped to the harness."))
		return FALSE
	if(!victim.handcuffed || !victim.legcuffed)
		to_chat(user, span_warning("[victim] needs to be both handcuffed and legcuffed first!"))
		return FALSE
	if(victim.mob_size > wearer.mob_size)
		to_chat(user, span_warning("[victim] is too large for you to strap down like this!"))
		return FALSE

	return TRUE

/datum/component/bellyriding/proc/update_visuals()
	if(!current_victim)
		return

	var/mob/living/carbon/human/wearer = parent
	if(QDELETED(current_victim) || current_victim.buckled != wearer)
		unbuckle_victim(TRUE)
		return

	current_victim.setDir(wearer.dir)

	var/x_offset = 0
	var/y_offset = 0
	switch(wearer.dir)
		if(EAST)
			x_offset = 10
			y_offset = -2
		if(WEST)
			x_offset = -10
			y_offset = -2
		if(NORTH)
			y_offset = 10
		if(SOUTH)
			y_offset = -10

	current_victim.set_mob_offsets("bellyride", _x = x_offset, _y = y_offset)
	var/base_layer = max(wearer.layer, ABOVE_MOB_LAYER)
	var/layer_offset = (wearer.dir == SOUTH) ? 0.1 : 0.05
	current_victim.layer = base_layer + layer_offset

/datum/component/bellyriding/proc/maybe_do_interaction()
	var/mob/living/carbon/human/wearer = parent
	if(!current_victim || wearer.stat != CONSCIOUS || !enable_interactions)
		return
	if(current_victim.buckled != wearer)
		unbuckle_victim(TRUE)
		return

	if(!wearer.getorganslot(ORGAN_SLOT_PENIS))
		return

	if(!ensure_sex_session())
		return

	var/fallback_action_type = /datum/sex_action/bellyriding/frot
	var/datum/sex_action/fallback_action = SEX_ACTION(fallback_action_type)
	if(!fallback_action || !fallback_action.can_perform(wearer, current_victim))
		fallback_action_type = /datum/sex_action/bellyriding/groin_rub

	var/datum/sex_action/previous_action = SEX_ACTION(last_action_type)
	if(isnull(last_action_type) || !previous_action || !previous_action.can_perform(wearer, current_victim))
		last_action_type = fallback_action_type
		goto do_the_violate

	if(last_action_type == fallback_action_type)
		if(prob(80))
			goto do_the_violate

		var/list/possible_actions = list(/datum/sex_action/bellyriding/anal, /datum/sex_action/bellyriding/vaginal)
		shuffle_inplace(possible_actions)
		for(var/candidate_type in possible_actions)
			var/datum/sex_action/candidate = SEX_ACTION(candidate_type)
			if(candidate && candidate.can_perform(wearer, current_victim))
				last_action_type = candidate_type
				break

		goto do_the_violate

	else if(prob(0.5))
		var/obj/item/organ/genitals/penis/penis = wearer.getorganslot(ORGAN_SLOT_PENIS)
		var/penis_name = "cock"
		if(penis)
			penis_name = penis.name
		wearer.visible_message(
			span_love("[wearer]'s [penis_name] slips out of [current_victim]'s orifice!"),
			span_love("Your [penis_name] slips out of [current_victim]'s hole!"),
			ignored_mobs = list(current_victim)
		)
		to_chat(current_victim, span_love("[wearer]'s [penis_name] slips out of your hole!"))
		playsound(current_victim, pick('sound/vo/kiss (1).ogg', 'sound/vo/kiss (2).ogg'), 50, TRUE, -6)
		last_action_type = null
		return

	do_the_violate:
	var/datum/sex_action/chosen_action = SEX_ACTION(last_action_type)
	if(chosen_action)
		ASYNC chosen_action.on_perform(wearer, current_victim)

/datum/component/bellyriding/proc/ensure_sex_session()
	if(!current_victim)
		return null

	var/datum/sex_session/session = get_sex_session(parent, current_victim)
	if(!session)
		session = get_sex_session(current_victim, parent)
	if(!session)
		session = new /datum/sex_session(parent, current_victim)
		LAZYADD(GLOB.sex_sessions, session)
	return session

/datum/component/bellyriding/proc/on_any_unbuckle(datum/source, atom/movable/M, force)
	if(M == current_victim)
		unbuckle_victim(TRUE)

/datum/component/bellyriding/proc/on_victim_deleted(datum/_source)
	SIGNAL_HANDLER
	unbuckle_victim(TRUE)

/datum/action/innate/toggle_bellyriding_heehee_pp
	name = "Toggle Bellyriding Interactions"
	desc = "Toggle whether to actually perform bellyriding interactions on your victim or not."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "shieldsparkles"
	active = TRUE

/datum/action/innate/toggle_bellyriding_heehee_pp/Activate()
	var/datum/component/bellyriding/comp = owner.GetComponent(/datum/component/bellyriding)
	if(!comp)
		return
	comp.enable_interactions = TRUE
	active = TRUE
	build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

	if(comp.current_victim)
		to_chat(comp.current_victim, span_notice("[owner] repositions you, your rear pressing against [owner.p_their()] eager cock.. Oh no."))
		to_chat(owner, span_notice("You reposition [comp.current_victim] to rest against your eager cock."))

/datum/action/innate/toggle_bellyriding_heehee_pp/Deactivate()
	var/datum/component/bellyriding/comp = owner.GetComponent(/datum/component/bellyriding)
	if(!comp)
		return
	comp.enable_interactions = FALSE
	active = FALSE
	build_all_button_icons(UPDATE_BUTTON_BACKGROUND)

	if(comp.current_victim)
		to_chat(comp.current_victim, span_notice("[owner] moves you out of [owner.p_their()] cock's way.. relief at last."))
		to_chat(owner, span_notice("You move [comp.current_victim] out of your cock's way.. for now."))
