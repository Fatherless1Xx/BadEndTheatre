/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/cry
	key = "cry"
	key_third_person = "cries"
	message = "cries."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_cry()
	set name = "Cry"
	set category = "Noises"

	emote("cry", intentional = TRUE)

/datum/emote/living/carbon/human/cry/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.silent || !C.can_speak())
			message = "makes a noise. Tears stream down their face."

/datum/emote/living/carbon/human/eyebrow
	key = "eyebrow"
	message = "raises an eyebrow."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_eyebrow()
	set name = "Raise Eyebrow"
	set category = "Emotes"

	emote("eyebrow", intentional = TRUE)

/datum/emote/living/carbon/human/psst
	key = "psst"
	key_third_person = "pssts"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE

/mob/living/carbon/human/verb/emote_psst()
	set name = "Psst"
	set category = "Noises"

	emote("psst", intentional = TRUE)

/datum/emote/living/carbon/human/grumble
	key = "grumble"
	key_third_person = "grumbles"
	message = "grumbles."
	message_muffled = "makes a grumbling noise."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/verb/emote_grumble()
	set name = "Grumble"
	set category = "Noises"

	emote("grumble", intentional = TRUE)

/datum/emote/living/carbon/human/handshake
	key = "handshake"
	message = "shakes their own hands."
	message_param = "shakes hands with %t."
	hands_use_check = TRUE
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/feel
	key = "feel"
	emote_type = EMOTE_VISIBLE
	nomsg = TRUE

/datum/emote/living/carbon/human/feel/run_emote(mob/user, params, type_override, intentional, targetted, forced)
	if(!can_run_emote(user, !forced, intentional))
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	var/list/options = list("Desire", "Dread")
	var/choice = input(H, "What feeling do you want to express?", "Feel") as null|anything in options
	if(!choice)
		return FALSE

	var/list/degrees = list("mild", "moderate", "strong")
	var/degree = input(H, "Select degree:", "Degree") as null|anything in degrees
	if(!degree)
		return FALSE

	if(choice == "Desire")
		var/desire = input(H, "What is the desire?", "Desire") as null|text
		if(isnull(desire))
			return FALSE
		var/strength_word = "strongly"
		if(degree == "mild")
			strength_word = "slightly"
		else if(degree == "moderate")
			strength_word = "moderately"
		var/message = "You [strength_word] want to help [H.real_name] fulfil their wish to [desire]"
		if(!length(message) || copytext(message, length(message)) != ".")
			message += "."
		for(var/mob/living/carbon/human/receiver in viewers(H, null))
			if(HAS_TRAIT(receiver, TRAIT_EMPATH))
				to_chat(receiver, "<span style='color: white; font-style: italic; text-shadow: 0 0 6px #fff, 0 0 12px #fff;'>[message]</span>")
		to_chat(H, "You desire [desire].")
		return TRUE

	if(choice == "Dread")
		var/dread = input(H, "What are you dreading?", "Dread") as null|text
		if(isnull(dread))
			return FALSE
		var/degree_adverb = "[degree]ly"
		var/message = "You feel [degree_adverb] negatively preoccupied with the prospect of [dread]."
		if(!length(message) || copytext(message, length(message)) != ".")
			message += "."
		for(var/mob/living/carbon/human/receiver in viewers(H, null))
			if(HAS_TRAIT(receiver, TRAIT_EMPATH))
				to_chat(receiver, "<span style='color: #ff4444; font-weight: bold;'>[message]</span>")
		to_chat(H, "You become preoccupied with [dread].")
		return TRUE

	return TRUE

/mob/living/carbon/human/verb/emote_feel()
	set name = "Feel (Desire/Dread)"
	set category = "Emotes"

	emote("feel", intentional = TRUE)


/datum/emote/living/carbon/human/mumble
	key = "mumble"
	key_third_person = "mumbles"
	message = "mumbles."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/human/pale
	key = "pale"
	message = "goes pale for a second."

/datum/emote/living/carbon/human/raise
	key = "raise"
	key_third_person = "raises"
	message = "raises a hand."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/salute
	key = "salute"
	key_third_person = "salutes"
	message = "salutes."
	message_param = "salutes to %t."
	hands_use_check = TRUE

/datum/emote/living/carbon/human/shrug
	key = "shrug"
	key_third_person = "shrugs"
	message = "shrugs."

/datum/emote/living/carbon/human/wag
	key = "wag"
	key_third_person = "wags"
	message = "wags their tail."

/datum/emote/living/carbon/human/wag/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.dna || !H.dna.species || !H.dna.species.can_wag_tail(H))
		return
	if(!H.dna.species.is_wagging_tail())
		H.dna.species.start_wagging_tail(H)
	else
		H.dna.species.stop_wagging_tail(H)

/datum/emote/living/carbon/human/wag/can_run_emote(mob/user, status_check = TRUE , intentional)
	if(!..())
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna && H.dna.species && H.dna.species.can_wag_tail(user)

/datum/emote/living/carbon/human/wag/select_message_type(mob/user, intentional)
	. = ..()
	var/mob/living/carbon/human/H = user
	if(!H.dna || !H.dna.species)
		return
	if(H.dna.species.is_wagging_tail())
		. = null

/datum/emote/living/carbon/human/rakshari

/datum/emote/living/carbon/human/rakshari/meow
	key = "meow"
	key_third_person = "meows"
	message = "meows!"
	message_muffled = "meows silently."
	emote_type = EMOTE_VISIBLE | EMOTE_AUDIBLE
	vary = TRUE
	sound = SFX_CAT_MEOW

/datum/emote/living/carbon/human/rakshari/purr
	key = "purr"
	key_third_person = "purrs"
	vary = TRUE
	sound = SFX_CAT_PURR
	message = "purrs."
	emote_type = EMOTE_AUDIBLE

/mob/living/carbon/human/species/rakshari/verb/emote_purr()
	set name = "purr"
	set category = "Noises"
	emote("purr", intentional = TRUE)

/mob/living/carbon/human/species/rakshari/verb/emote_meow()
	set name = "meow"
	set category = "Noises"
	emote("meow", intentional = TRUE)

//Ayy lmao
