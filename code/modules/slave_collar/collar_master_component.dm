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

/datum/component/collar_master/Initialize(...)
	. = ..()
	mindparent = parent
	GLOB.collar_masters += mindparent

/datum/component/collar_master/Destroy(force, silent)
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
	UnregisterSignal(pet, list(COMSIG_MOB_SAY, COMSIG_MOB_DEATH, COMSIG_MOVABLE_HEAR, COMSIG_MOB_ATTACK_HAND, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_ITEM_ATTACK))
	if(listening_pet == pet)
		listening = FALSE
		listening_pet = null
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
	listening = !listening
	listening_pet = listening ? pet : null
	if(listening)
		RegisterSignal(pet, COMSIG_MOVABLE_HEAR, PROC_REF(relay_heard))
	else
		UnregisterSignal(pet, list(COMSIG_MOVABLE_HEAR))
	return TRUE

/datum/component/collar_master/proc/relay_heard(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	if(!listening || source != listening_pet || !mindparent?.current)
		return
	var/message = hearing_args[HEARING_MESSAGE]
	if(message)
		to_chat(mindparent.current, span_notice("<i>Through [listening_pet]'s collar: [message]</i>"))

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
		shock_pet(pet, 15)
