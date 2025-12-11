/datum/component/bellyriding
	/// Who is currently attached to us?
	var/mob/living/carbon/human/current_victim
	/// How many steps until we try another interaction tick.
	var/steps_until_interaction = 4
	/// Last action we successfully ran, used to bias repeats that are still valid.
	var/last_action_type

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
	RegisterSignal(buckle_relay, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))

/datum/component/bellyriding/Destroy(force)
	unbuckle_victim(TRUE)
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
		maybe_do_interaction()
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

	var/torturer_message = span_warning("You start fastening [victim] to your harness...")
	var/victim_message = span_warning("[wearer] starts fastening you to [wearer.p_their()] harness!")
	var/observer_message = span_warning("[wearer] starts fastening [victim] to [wearer.p_their()] harness!")

	user.visible_message(observer_message, torturer_message, ignored_mobs = list(victim))
	to_chat(victim, victim_message)

	if(!do_after(user, 3 SECONDS, victim))
		restore_old_state(victim)
		return

	if(!wearer.buckle_mob(victim, TRUE, TRUE))
		restore_old_state(victim)
		return

	if(victim.buckled != wearer)
		restore_old_state(victim)
		return

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

	if(victim && !QDELETED(victim))
		victim.reset_offsets("bellyride")
		victim.layer = initial(victim.layer)
	UnregisterSignal(victim, COMSIG_PARENT_QDELETING)

/datum/component/bellyriding/proc/store_old_state(mob/living/carbon/human/victim)
	var/mob/living/carbon/human/wearer = parent
	old_can_buckle = wearer.can_buckle
	old_buckle_requires_restraints = wearer.buckle_requires_restraints
	old_max_buckled_mobs = wearer.max_buckled_mobs
	wearer.can_buckle = TRUE
	wearer.buckle_requires_restraints = TRUE
	wearer.max_buckled_mobs = max(wearer.max_buckled_mobs + 1, 1)

/datum/component/bellyriding/proc/restore_old_state(mob/living/carbon/human/victim)
	var/mob/living/carbon/human/wearer = parent
	wearer.can_buckle = old_can_buckle
	wearer.buckle_requires_restraints = old_buckle_requires_restraints
	if(old_max_buckled_mobs)
		wearer.max_buckled_mobs = old_max_buckled_mobs

/datum/component/bellyriding/proc/update_visuals()
	if(!current_victim)
		return

	var/mob/living/carbon/human/wearer = parent

	current_victim.setDir(wearer.dir)

	var/x_offset = 0
	var/y_offset = 4
	switch(wearer.dir)
		if(EAST)
			x_offset = 6
		if(WEST)
			x_offset = -6
		if(NORTH)
			y_offset = 6
		if(SOUTH)
			y_offset = 2

	current_victim.set_mob_offsets("bellyride", _x = x_offset, _y = y_offset)
	current_victim.layer = wearer.layer + 0.001

/datum/component/bellyriding/proc/maybe_do_interaction()
	var/mob/living/carbon/human/wearer = parent
	if(!current_victim || wearer.stat != CONSCIOUS || !prob(25))
		return
	if(current_victim.buckled != wearer)
		unbuckle_victim(TRUE)
		return

	if(!wearer.getorganslot(ORGAN_SLOT_PENIS))
		return

	if(!ensure_sex_session())
		return

	var/list/candidates = list(/datum/sex_action/bellyriding/groin_rub)
	if(current_victim.getorganslot(ORGAN_SLOT_PENIS))
		candidates += /datum/sex_action/bellyriding/frot
	if(current_victim.getorganslot(ORGAN_SLOT_VAGINA))
		candidates += /datum/sex_action/bellyriding/vaginal
	if(current_victim.getorganslot(ORGAN_SLOT_ANUS))
		candidates += /datum/sex_action/bellyriding/anal

	var/action_type = null
	if(last_action_type)
		var/datum/sex_action/previous_action = SEX_ACTION(last_action_type)
		if(previous_action?.can_perform(wearer, current_victim))
			action_type = last_action_type

	if(!action_type)
		shuffle_inplace(candidates)
		for(var/choice in candidates)
			var/datum/sex_action/action = SEX_ACTION(choice)
			if(action.can_perform(wearer, current_victim))
				action_type = choice
				break

	if(!action_type)
		return

	var/datum/sex_action/chosen_action = SEX_ACTION(action_type)
	chosen_action.on_perform(wearer, current_victim)
	last_action_type = action_type

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

/datum/component/bellyriding/proc/on_victim_deleted(datum/_source)
	SIGNAL_HANDLER
	unbuckle_victim(TRUE)
