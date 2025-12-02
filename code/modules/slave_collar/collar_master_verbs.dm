/mob/proc/collar_master_control_menu()
	set name = "Collar Control"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM)
		return

	var/list/valid_pets = list()
	for(var/mob/living/carbon/human/pet in CM.my_pets)
		if(!pet || !pet.mind || !pet.client)
			continue
		valid_pets[pet.real_name] = pet
	if(!length(valid_pets))
		to_chat(src, span_warning("No valid pets available!"))
		return

	var/list/selected = input(src, "Select pets to command:", "Pet Selection") as null|anything in valid_pets
	if(!selected)
		return

	CM.temp_selected_pets = list(valid_pets[selected])

	var/list/options = list(
		"Listen to Pets" = /mob/proc/collar_master_listen,
		"Shock Pets" = /mob/proc/collar_master_shock,
		"Send Message" = /mob/proc/collar_master_send_message,
		"Force Surrender" = /mob/proc/collar_master_force_surrender,
		"Force Strip" = /mob/proc/collar_master_force_strip,
		"Forbid/permit Clothing" = /mob/proc/collar_master_clothing,
		"Toggle Pet Speech" = /mob/proc/collar_master_toggle_speech,
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
	CM.toggle_listening(pet)
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
