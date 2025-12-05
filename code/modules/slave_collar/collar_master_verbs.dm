/mob/proc/collar_master_control_menu()
	set name = "Collar Control"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM)
		return

	var/list/valid_pets = list()
	var/list/namecounts = list()
	for(var/mob/living/carbon/human/pet in CM.my_pets)
		if(!pet || !pet.mind)
			continue
		var/label = avoid_assoc_duplicate_keys(pet.real_name, namecounts)
		valid_pets[label] = pet
	if(!length(valid_pets))
		to_chat(src, span_warning("No valid pets available!"))
		return

	var/list/selected = input(src, "Select pets to command:", "Pet Selection") as null|anything in valid_pets
	if(!selected)
		return

	CM.temp_selected_pets.Cut()
	if(islist(selected))
		for(var/choice in selected)
			var/mob/living/carbon/human/pet_choice = valid_pets[choice]
			if(pet_choice)
				CM.temp_selected_pets += pet_choice
	else
		var/mob/living/carbon/human/pet_choice = valid_pets[selected]
		if(pet_choice)
			CM.temp_selected_pets = list(pet_choice)
	if(!length(CM.temp_selected_pets))
		to_chat(src, span_warning("No valid pets available!"))
		return

	var/list/options = list(
		"Listen to Pets" = /mob/proc/collar_master_listen,
		"Shock Pets" = /mob/proc/collar_master_shock,
		"Send Message" = /mob/proc/collar_master_send_message,
		"Force Surrender" = /mob/proc/collar_master_force_surrender,
		"Force Strip" = /mob/proc/collar_master_force_strip,
		"Forbid/permit Clothing" = /mob/proc/collar_master_clothing,
		"Toggle Pet Speech" = /mob/proc/collar_master_toggle_speech,
		"Force Love" = /mob/proc/collar_master_force_love,
		"Force Say" = /mob/proc/collar_master_force_say,
		"Force Emote" = /mob/proc/collar_master_force_emote,
		"Toggle Arousal" = /mob/proc/collar_master_toggle_arousal,
		"Scry Pet" = /mob/proc/collar_master_scry,
		"Remote Control Pet" = /mob/proc/collar_master_remote_control,
		"Free Pet" = /mob/proc/collar_master_release_pet,
	)

	var/choice = input(src, "Choose a command:", "Collar Control") as null|anything in options
	if(!choice || !length(CM.temp_selected_pets))
		return
	call(src, options[choice])()

/mob/proc/collar_master_listen()
	set name = "Listen to Pets"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return
	var/mob/living/carbon/human/pet = CM.temp_selected_pets[1]
	if(!pet || pet.stat >= UNCONSCIOUS || !(pet in CM.my_pets))
		return
	var/now_listening = CM.toggle_listening(pet)
	if(now_listening)
		to_chat(src, span_notice("You tune in to [pet]'s surroundings."))
	else
		to_chat(src, span_notice("You stop listening through [pet]'s collar."))
	CM.last_command_time = world.time

/mob/proc/collar_master_shock()
	set name = "Shock Pet"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's power cell is still recharging!"))
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets) || pet.stat >= UNCONSCIOUS)
			continue
		CM.shock_pet(pet, 15)

/mob/proc/collar_master_send_message()
	set name = "Send Message"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's neural link is still recharging!"))
		return
	var/message = input(src, "What message should echo in your pet's mind?", "Mental Command") as text|null
	if(!message)
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		CM.send_message(pet, message)

/mob/proc/collar_master_force_surrender()
	set name = "Force Surrender"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		CM.force_surrender(pet)

/mob/proc/collar_master_force_strip()
	set name = "Force Strip"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's circuits are still cooling down!"))
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		CM.force_strip(pet)

/mob/proc/collar_master_clothing()
	set name = "Clothing Permission"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's behavioral circuits need time to recalibrate!"))
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		if(HAS_TRAIT_FROM(pet, TRAIT_NUDIST, COLLAR_TRAIT))
			CM.permit_clothing(pet, TRUE)
		else
			CM.permit_clothing(pet, FALSE)

/mob/proc/collar_master_toggle_speech()
	set name = "Toggle Speech"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's vocal inhibitors need time to cycle!"))
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		CM.toggle_speech(pet)

/mob/proc/collar_master_force_love()
	set name = "Force Love"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's heart sigils are still pulsing!"))
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		CM.force_love(pet)

/mob/proc/collar_master_force_say()
	set name = "Force Say"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's voice modulator is still warming up!"))
		return
	var/message = input(src, "Force your pet to say:", "Collar Command") as text|null
	if(!message)
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		CM.force_say(pet, message)

/mob/proc/collar_master_force_emote()
	set name = "Force Emote"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's emotive circuit hums; wait a moment."))
		return
	var/message = input(src, "Force your pet to emote:", "Collar Command") as text|null
	if(!message)
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		CM.force_emote(pet, message)

/mob/proc/collar_master_toggle_arousal()
	set name = "Toggle Arousal"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's tease nodes are still cycling!"))
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		CM.toggle_arousal(pet)

/mob/proc/collar_master_scry()
	set name = "Scry Pet"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's vision is still refocusing!"))
		return
	var/mob/living/carbon/human/pet = CM.temp_selected_pets[1]
	if(!pet || !(pet in CM.my_pets))
		return
	if(!CM.scry_pet(pet))
		to_chat(src, span_warning("The collar refuses to share that pet's sight."))
		return
	CM.last_command_time = world.time

/mob/proc/collar_master_remote_control()
	set name = "Remote Control"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar's circuits are still recalibrating!"))
		return
	var/mob/living/carbon/human/pet = CM.temp_selected_pets[1]
	if(!pet || !(pet in CM.my_pets))
		return
	if(!CM.remote_control_pet(pet, 30 SECONDS))
		to_chat(src, span_warning("The collar cannot link you to that pet right now."))
		return
	CM.last_command_time = world.time

/mob/proc/collar_master_release_pet()
	set name = "Release Pet"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM || !length(CM.temp_selected_pets))
		return
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(src, span_warning("The collar is still cooling down!"))
		return
	var/confirm = alert("Release selected pets?", "Release Confirmation", "Yes", "No")
	if(confirm != "Yes")
		return
	CM.last_command_time = world.time
	for(var/mob/living/carbon/human/pet in CM.temp_selected_pets)
		if(!pet || !(pet in CM.my_pets))
			continue
		var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(ITEM_SLOT_NECK)
		if(istype(collar))
			REMOVE_TRAIT(collar, TRAIT_NODROP, "cursed_collar")
			pet.dropItemToGround(collar, force = TRUE)
		CM.cleanup_pet(pet)
	CM.temp_selected_pets.Cut()

/mob/proc/collar_master_help()
	set name = "Collar Help"
	set category = "Collar Tab"
	to_chat(src, span_notice("Use the collar control menu to manage pets. Commands have short cooldowns."))

/mob/proc/collar_master_releaseall()
	set name = "Release All Pets"
	set category = "Collar Tab"
	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM)
		return
	qdel(CM)
