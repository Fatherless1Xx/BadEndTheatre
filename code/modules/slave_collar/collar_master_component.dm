#define COLLAR_TRAIT "collar_master"

GLOBAL_LIST_EMPTY(collar_masters)

/datum/component/collar_master
	var/datum/mind/mindparent
	var/list/my_pets = list()
	var/list/temp_selected_pets = list()
	var/listening = FALSE
	var/mob/living/carbon/human/listening_pet
	var/last_command_time = 0
	var/command_cooldown = 2 SECONDS
	var/list/speech_blocked = list()
	var/remote_control_timer_id
	var/mob/living/remote_control_master_body
	var/mob/living/carbon/human/remote_control_pet_body
	var/datum/mind/remote_control_pet_mind
	var/mob/dead/observer/remote_control_pet_ghost
	var/list/forced_arousal_timers = list()

/datum/component/collar_master/Initialize(...)
	. = ..()
	mindparent = parent
	GLOB.collar_masters += mindparent

/datum/component/collar_master/Destroy(force, silent)
	end_remote_control()
	. = ..()
	for(var/mob/living/carbon/human/pet in my_pets.Copy())
		cleanup_pet(pet)
	GLOB.collar_masters -= mindparent

/datum/component/collar_master/_JoinParent()
	. = ..()
	if(mindparent?.current)
		mindparent.current.verbs += list(
			/mob/proc/collar_master_control_menu,
			/mob/proc/collar_master_help
		)

/datum/component/collar_master/_RemoveFromParent()
	if(mindparent?.current)
		mindparent.current.verbs -= list(
			/mob/proc/collar_master_control_menu,
			/mob/proc/collar_master_help
		)
	. = ..()

/datum/component/collar_master/proc/add_pet(mob/living/carbon/human/pet)
	if(!pet || (pet in my_pets))
		return FALSE
	my_pets += pet
	RegisterSignal(pet, COMSIG_MOB_SAY, PROC_REF(on_pet_say))
	RegisterSignal(pet, COMSIG_MOB_DEATH, PROC_REF(on_pet_death))
	RegisterSignal(pet, COMSIG_MOB_ATTACK_HAND, PROC_REF(on_pet_attack))
	RegisterSignal(pet, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_pet_attack))
	RegisterSignal(pet, COMSIG_ITEM_ATTACK, PROC_REF(on_pet_attack))
	return TRUE

/datum/component/collar_master/proc/remove_pet(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(listening_pet == pet)
		stop_listening()
	UnregisterSignal(pet, list(COMSIG_MOB_SAY, COMSIG_MOB_DEATH, COMSIG_MOVABLE_HEAR, COMSIG_MOB_ATTACK_HAND, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_ITEM_ATTACK))
	speech_blocked -= pet
	my_pets -= pet
	return TRUE

/datum/component/collar_master/proc/on_pet_say(datum/source, list/speech_args)
	SIGNAL_HANDLER
	return

/datum/component/collar_master/proc/on_pet_death(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(pet)
		INVOKE_ASYNC(src, PROC_REF(cleanup_pet), pet)

/datum/component/collar_master/proc/shock_pet(mob/living/carbon/human/pet, intensity = 10)
	if(!pet || !(pet in my_pets))
		return FALSE
	pet.adjust_stamina(intensity)
	pet.adjustFireLoss(intensity * 0.2)
	pet.Knockdown(intensity * 0.2 SECONDS)
	pet.visible_message(span_danger("[pet]'s collar crackles with electricity!"), span_userdanger("Your collar sears you with a shock!"))
	playsound(pet, 'sound/items/stunmace_hit (1).ogg', 50, TRUE)
	return TRUE

/datum/component/collar_master/proc/toggle_listening(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(listening_pet == pet)
		stop_listening()
		return FALSE
	stop_listening()
	start_listening(pet)
	return TRUE

/datum/component/collar_master/proc/start_listening(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	listening = TRUE
	listening_pet = pet
	RegisterSignal(pet, COMSIG_MOVABLE_HEAR, PROC_REF(relay_heard))
	return TRUE

/datum/component/collar_master/proc/stop_listening()
	if(listening_pet)
		UnregisterSignal(listening_pet, list(COMSIG_MOVABLE_HEAR))
	listening = FALSE
	listening_pet = null
	return TRUE

/datum/component/collar_master/proc/relay_heard(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	if(!listening || source != listening_pet || !mindparent?.current)
		return
	if(mindparent.current == listening_pet)
		return
	if(LAZYLEN(hearing_args) && hearing_args[HEARING_MESSAGE])
		// Relay the full hearing payload so the master hears what the pet hears.
		mindparent.current.Hear(arglist(hearing_args))

/datum/component/collar_master/proc/log_collar_action(mob/living/actor, action, list/pets, extra_text)
	if(!actor || !mindparent)
		return
	var/list/pet_names = list()
	for(var/mob/living/carbon/human/P as anything in pets)
		if(P)
			pet_names += key_name(P, TRUE)
	var/pet_blob = pet_names.len ? pet_names.Join(", ") : "none"
	var/msg = "[key_name(actor, TRUE)] used collar command '[action]' on [pet_blob]"
	if(extra_text)
		msg += " ([extra_text])"
	msg += "."
	log_admin(msg)
	message_admins(span_adminnotice(msg))

/datum/component/collar_master/proc/force_surrender(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(pet.stat >= UNCONSCIOUS)
		return FALSE
	pet.Knockdown(50)
	pet.Stun(50)
	pet.visible_message(span_warning("[pet] is forced to surrender by their collar!"), span_userdanger("Your collar forces you to submit!"))
	playsound(pet, 'sound/misc/surrender.ogg', 80, TRUE)
	return TRUE

/datum/component/collar_master/proc/force_strip(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	pet.drop_all_held_items()
	for(var/obj/item/I in pet.get_equipped_items())
		if(!(I.slot_flags & ITEM_SLOT_NECK))
			pet.dropItemToGround(I, TRUE)
	to_chat(pet, span_warning("Your collar tingles as it forces you to strip!"))
	return TRUE

/datum/component/collar_master/proc/toggle_speech(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(pet in speech_blocked)
		UnregisterSignal(pet, COMSIG_MOB_SAY)
		speech_blocked -= pet
		to_chat(pet, span_notice("Your collar relaxes; you can speak normally."))
	else
		RegisterSignal(pet, COMSIG_MOB_SAY, PROC_REF(block_speech))
		speech_blocked += pet
		to_chat(pet, span_warning("Your collar locks your voice down to whimpers."))
	return TRUE

/datum/component/collar_master/proc/block_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet)
		return
	pet.visible_message(span_emote("[pet] whimpers."), span_warning("You can only whimper through the collar."))
	speech_args[SPEECH_MESSAGE] = ""

/datum/component/collar_master/proc/permit_clothing(mob/living/carbon/human/pet, permitted = TRUE)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(permitted)
		REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
	else
		ADD_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
	return TRUE

/datum/component/collar_master/proc/send_message(mob/living/carbon/human/pet, message)
	if(!pet || !(pet in my_pets) || !message)
		return FALSE
	to_chat(pet, span_userdanger("<i>Your collar resonates with your master's voice:</i> [message]"))
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	return TRUE

/datum/component/collar_master/proc/force_love(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets) || !mindparent?.current)
		return FALSE
	if(pet.has_status_effect(/datum/status_effect/in_love))
		pet.remove_status_effect(/datum/status_effect/in_love)
		if(islist(pet.faction))
			pet.faction -= "[REF(mindparent.current)]"
		to_chat(pet, span_notice("The collar releases the enforced affection toward [mindparent.current]."))
		to_chat(mindparent.current, span_notice("[pet]'s collar no longer twists their heart."))
		return TRUE
	if(!islist(pet.faction))
		pet.faction = list()
	pet.faction |= "[REF(mindparent.current)]"
	pet.apply_status_effect(/datum/status_effect/in_love, null, mindparent.current)
	to_chat(pet, span_love("Overwhelming adoration for [mindparent.current] floods your mind."))
	to_chat(mindparent.current, span_notice("[pet] is bound to you by the collar's twisted affection."))
	return TRUE

/datum/component/collar_master/proc/force_say(mob/living/carbon/human/pet, message)
	if(!pet || !(pet in my_pets) || !message)
		return FALSE
	var/was_blocked = (pet in speech_blocked)
	if(was_blocked)
		UnregisterSignal(pet, COMSIG_MOB_SAY)
	pet.say(message, forced = TRUE)
	if(was_blocked)
		RegisterSignal(pet, COMSIG_MOB_SAY, PROC_REF(block_speech))
	return TRUE

/datum/component/collar_master/proc/force_emote(mob/living/carbon/human/pet, message)
	if(!pet || !(pet in my_pets) || !message)
		return FALSE
	pet.emote("me", 1, message, FALSE, TRUE, TRUE)
	return TRUE

/datum/component/collar_master/proc/toggle_arousal(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(forced_arousal_timers[pet])
		stop_forced_arousal(pet)
		to_chat(pet, span_notice("The collar eases its constant teasing."))
		if(mindparent?.current)
			to_chat(mindparent.current, span_notice("[pet]'s enforced arousal is switched off."))
		return TRUE
	SEND_SIGNAL(pet, COMSIG_SEX_FREEZE_AROUSAL, FALSE)
	to_chat(pet, span_warning("The collar hums, flooding you with relentless arousal."))
	if(mindparent?.current)
		to_chat(mindparent.current, span_notice("You set [pet]'s collar to steadily increase their arousal."))
	var/id = addtimer(CALLBACK(src, PROC_REF(ramp_arousal_tick), pet), 2 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)
	if(id)
		forced_arousal_timers[pet] = id
	return TRUE

/datum/component/collar_master/proc/ramp_arousal_tick(mob/living/carbon/human/pet)
	if(!pet || QDELETED(pet) || !(pet in my_pets) || pet.stat >= DEAD)
		stop_forced_arousal(pet)
		return
	SEND_SIGNAL(pet, COMSIG_SEX_ADJUST_AROUSAL, 2)

/datum/component/collar_master/proc/stop_forced_arousal(mob/living/carbon/human/pet)
	if(!forced_arousal_timers[pet])
		return
	var/id = forced_arousal_timers[pet]
	forced_arousal_timers -= pet
	if(id)
		deltimer(id)
	return TRUE

/datum/component/collar_master/proc/cleanup_pet(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE
	if(remote_control_pet_body == pet)
		end_remote_control()
	stop_forced_arousal(pet)
	remove_pet(pet)
	REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
	return TRUE

/datum/component/collar_master/proc/on_pet_attack(datum/source, atom/target)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets))
		return
	if(!mindparent?.current)
		return
	if(target == mindparent.current && pet.used_intent && pet.used_intent.type == INTENT_HARM)
		to_chat(pet, span_warning("Your collar shocks you for attacking your master!"))
		// Run the shock asynchronously so we don't block the signal handler on any sleeping subcalls (emotes, etc.)
		INVOKE_ASYNC(src, PROC_REF(shock_pet), pet, 15)

/datum/component/collar_master/proc/scry_pet(mob/living/carbon/human/pet, duration = 10 SECONDS)
	if(!pet || !(pet in my_pets) || pet.stat >= DEAD)
		return FALSE
	if(!mindparent?.current || !mindparent.current.client)
		return FALSE
	var/mob/living/viewer = mindparent.current
	var/mob/dead/observer/screye/eye = viewer.scry_ghost()
	if(!eye)
		return FALSE
	eye.ManualFollow(pet)
	eye.name = "[viewer.real_name]'s sight"
	to_chat(viewer, span_notice("You let your senses ride along [pet]'s collar."))
	addtimer(CALLBACK(eye, TYPE_PROC_REF(/mob/dead/observer, reenter_corpse)), duration)
	return TRUE

/datum/component/collar_master/proc/remote_control_pet(mob/living/carbon/human/pet, control_duration = 30 SECONDS)
	if(!pet || !(pet in my_pets) || pet.stat >= DEAD || !pet.mind)
		return FALSE
	if(remote_control_timer_id)
		if(mindparent?.current)
			to_chat(mindparent.current, span_warning("You are already controlling a pet. Finish that first."))
		return FALSE
	if(!mindparent?.current || !mindparent.current.client)
		return FALSE

	// Push the pet's player into a ghost for the duration.
	var/datum/mind/pet_mind = pet.mind
	var/mob/dead/observer/ghost = create_pet_ghost(pet)
	if(!ghost)
		if(mindparent?.current)
			to_chat(mindparent.current, span_warning("The collar fails to cast the pet's spirit out."))
		return FALSE
	ghost.can_reenter_corpse = FALSE
	to_chat(ghost, span_warning("Your spirit is yanked from your body by the cursed collar! You will be pulled back soon."))
	pet_mind.transfer_to(ghost, TRUE)
	if(pet_mind.current != ghost)
		if(mindparent?.current)
			to_chat(mindparent.current, span_warning("The collar fizzles; the link to the pet's spirit fails."))
		pet_ghost_cleanup(ghost)
		return FALSE

	var/mob/living/master_body = mindparent.current
	remote_control_master_body = master_body
	remote_control_pet_body = pet
	remote_control_pet_mind = pet_mind
	remote_control_pet_ghost = ghost

	// Move the master's mind into the pet.
	mindparent.transfer_to(pet)
	if(mindparent?.current)
		to_chat(mindparent.current, span_userdanger("You seize [pet]'s body through the cursed collar for a short while!"))

	remote_control_timer_id = addtimer(CALLBACK(src, PROC_REF(end_remote_control)), control_duration, TIMER_STOPPABLE)
	return TRUE

/datum/component/collar_master/proc/end_remote_control()
	if(remote_control_timer_id)
		deltimer(remote_control_timer_id)
	remote_control_timer_id = null
	var/mob/living/master_body = remote_control_master_body
	var/mob/living/carbon/human/pet_body = remote_control_pet_body
	var/datum/mind/pet_mind = remote_control_pet_mind
	var/mob/dead/observer/pet_ghost = remote_control_pet_ghost
	remote_control_master_body = null
	remote_control_pet_body = null
	remote_control_pet_mind = null
	remote_control_pet_ghost = null
	// Return minds to their original homes when possible.
	if(mindparent && master_body && !QDELETED(master_body) && mindparent.current != master_body)
		mindparent.transfer_to(master_body, TRUE)
	if(pet_mind && pet_body && !QDELETED(pet_body) && pet_mind.current != pet_body)
		pet_mind.transfer_to(pet_body, TRUE)
	if(pet_ghost && !QDELETED(pet_ghost))
		pet_ghost.reenter_corpse(TRUE)
	if(mindparent?.current)
		to_chat(mindparent.current, span_notice("The collar releases its hold; you return to your own body."))
	if(pet_mind?.current && pet_mind.current != mindparent?.current)
		to_chat(pet_mind.current, span_notice("Control of your body snaps back to you."))
	return TRUE

/datum/component/collar_master/proc/pet_ghost_cleanup(mob/dead/observer/ghost)
	if(ghost && !QDELETED(ghost))
		ghost.reenter_corpse(TRUE)
	return TRUE

/datum/component/collar_master/proc/create_pet_ghost(mob/living/carbon/human/pet)
	if(!pet?.client)
		return null
	var/mob/dead/observer/rogue/ghost = new(pet)
	SStgui.on_transfer(pet, ghost)
	ghost.key = pet.key
	ghost.can_reenter_corpse = FALSE
	ghost.name = "[pet.real_name]'s spirit"
	return ghost
