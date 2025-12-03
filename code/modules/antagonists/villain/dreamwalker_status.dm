// Minimal supporting pieces for dreamwalker marking and dream items.

// Status effect applied to marked targets by dreamwalker weapons.
/datum/status_effect/dream_mark
	id = "dream_mark"
	duration = 30 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/dream_mark

/datum/status_effect/dream_mark/on_apply()
	. = ..()
	if(!.)
		return FALSE
	to_chat(owner, span_userdanger("You feel your essence being pulled toward another realm. You've been marked by a dreamwalker!"))
	return TRUE

/datum/status_effect/dream_mark/on_remove()
	. = ..()
	if(!.)
		return FALSE
	to_chat(owner, span_notice("The connection to the dream realm fades."))
	return TRUE

/atom/movable/screen/alert/status_effect/dream_mark
	name = "Dream Marked"
	desc = "A dreamwalker has established a connection to your essence."
	icon_state = "dream_mark"

// Component to track marked targets and hits
/datum/component/dreamwalker_mark
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/marked_target = null
	var/hit_count = 0
	var/max_hits = 5
	var/mark_duration = 30 MINUTES

/datum/component/dreamwalker_mark/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_ITEM_ATTACK, .proc/on_attack)

/datum/component/dreamwalker_mark/Destroy()
	if(marked_target)
		if(marked_target.has_status_effect(/datum/status_effect/dream_mark))
			marked_target.remove_status_effect(/datum/status_effect/dream_mark)
		marked_target = null
	return ..()

/datum/component/dreamwalker_mark/proc/on_attack(mob/parent, mob/living/target, mob/user, obj/item/I)
	SIGNAL_HANDLER

	if(!marked_target)
		marked_target = target

	if(target != marked_target)
		return

	if(!(I.item_flags & DREAM_ITEM))
		return

	if(marked_target.has_status_effect(/datum/status_effect/dream_mark))
		return

	hit_count++
	to_chat(user, span_notice("Your dream weapon strikes true. [hit_count]/[max_hits] hits to establish a connection."))

	if(hit_count >= max_hits)
		marked_target.apply_status_effect(/datum/status_effect/dream_mark, mark_duration)
		to_chat(user, span_warning("You've established a strong dream connection with [marked_target]!"))
		to_chat(marked_target, span_userdanger("You feel an unnatural connection forming with [user]."))

// Repairs dream items worn by the dreamwalker
/datum/component/dreamwalker_repair
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/repairing_items = list()
	var/process_interval = 5 SECONDS
	var/last_process = 0

/datum/component/dreamwalker_repair/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	to_chat(parent, span_userdanger("Your body pulses with strange dream energies."))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/on_item_equipped)
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, .proc/on_item_dropped)
	START_PROCESSING(SSprocessing, src)

/datum/component/dreamwalker_repair/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	repairing_items = null
	return ..()

/datum/component/dreamwalker_repair/process(delta_time)
	if(world.time < last_process + process_interval)
		return
	last_process = world.time

	for(var/obj/item/I in repairing_items)
		if(I.max_integrity)
			I.take_damage(-I.max_integrity * 0.01, BRUTE, "dreamrepair")
		if(I.blade_int && I.max_blade_int && I.blade_int < I.max_blade_int)
			I.add_bintegrity(min(I.blade_int + I.max_blade_int * 0.01, I.max_blade_int))

/datum/component/dreamwalker_repair/proc/on_item_equipped(atom/source, mob/user, slot)
	SIGNAL_HANDLER
	if(!isitem(source))
		return
	var/obj/item/I = source
	if(!(I.item_flags & DREAM_ITEM))
		return
	if(!(I in repairing_items))
		repairing_items += I

/datum/component/dreamwalker_repair/proc/on_item_dropped(atom/source, mob/user)
	SIGNAL_HANDLER
	if(!isitem(source))
		return
	var/obj/item/I = source
	if(!(I.item_flags & DREAM_ITEM))
		return
	repairing_items -= I

// Dream weapon component (on-hit effects and rejection for non-dreamwalkers)
/datum/component/dream_weapon
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/effect_type = null
	var/cooldown_time = 0
	var/next_use = 0

/datum/component/dream_weapon/Initialize(effect_type, cooldown_time)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	src.effect_type = effect_type
	src.cooldown_time = cooldown_time

	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, .proc/on_afterattack)
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/on_equipped)

/datum/component/dream_weapon/proc/on_afterattack(obj/item/source, atom/target, mob/living/user, proximity_flag, click_parameters)
	SIGNAL_HANDLER
	if(!effect_type)
		return
	if(world.time < next_use)
		return
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	switch(effect_type)
		if("fire")
			H.adjust_fire_stacks(4)
			target.visible_message(span_warning("[source] ignites [target] with strange flame!"))
		if("frost")
			H.apply_status_effect(/datum/status_effect/debuff/frostbite)
			target.visible_message(span_warning("[source] freezes [target] with scalding ice!"))
		if("poison")
			if(H.reagents)
				H.reagents.add_reagent(/datum/reagent/berrypoison, 2)
				target.visible_message(span_warning("[source] injects [target] with vile ooze!"))
	next_use = world.time + cooldown_time

/datum/component/dream_weapon/proc/on_equipped(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER
	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		return
	to_chat(user, span_userdanger("The weapon rejects your touch, burning with dream energy!"))
	user.dropItemToGround(source, TRUE)
