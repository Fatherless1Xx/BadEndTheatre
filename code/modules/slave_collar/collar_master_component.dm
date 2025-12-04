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
			/mob/proc/collar_master_help,
			/mob/proc/collar_master_releaseall
		)

/datum/component/collar_master/_RemoveFromParent()
	if(mindparent?.current)
		mindparent.current.verbs -= list(
			/mob/proc/collar_master_control_menu,
			/mob/proc/collar_master_help,
			/mob/proc/collar_master_releaseall
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
		cleanup_pet(pet)

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

/datum/component/collar_master/proc/cleanup_pet(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE
	if(remote_control_pet_body == pet)
		end_remote_control()
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
	var/mob/dead/observer/screye/ghost = pet.scry_ghost()
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
