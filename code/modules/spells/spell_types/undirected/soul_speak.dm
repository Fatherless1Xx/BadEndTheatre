/datum/action/cooldown/spell/undirected/soul_speak
	name = "Speak with Soul"
	desc = ""
	button_icon_state = "speakwithdead"
	sound = 'sound/magic/churn.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/necra)

	invocation = "Establishing mortal-to-spirit communication protocol."
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 1 SECONDS
	spell_cost = 0

	var/datum/weakref/soul

/datum/action/cooldown/spell/undirected/soul_speak/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/list/souloptions = list()
	for(var/mob/living/carbon/spirit/S in GLOB.spirit_list)
		if(S.summoned)
			continue
		if(!S.client)
			continue
		souloptions += S
	if(!length(souloptions))
		to_chat(owner, span_warning("I was unable to commune with a soul."))
		return . | SPELL_CANCEL_CAST

	var/mob/selected
	selected = browser_input_list(owner, "Which wandering soul shall I commune with?", "Available Souls", souloptions)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(selected) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(!selected)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	soul = WEAKREF(selected)

/datum/action/cooldown/spell/undirected/soul_speak/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/spirit/called = soul.resolve()
	if(QDELETED(called))
		return
	to_chat(called, span_userdanger("You feel yourself being pulled out of the Hell!"))
	SSdeath_arena.remove_fighter(called)

	var/list/itemstore = list()
	for(var/obj/item/I in called.held_items) // this is still ass
		called.temporarilyRemoveItemFromInventory(I, force = TRUE)
		itemstore += I.type
		qdel(I)
	called.summoned = TRUE
	called.beingmoved = TRUE
	called.invisibility = INVISIBILITY_OBSERVER
	called.status_flags |= GODMODE
	called.Stun(61 SECONDS)
	called.density = FALSE

	var/list/icon_dimensions = get_icon_dimensions(owner.icon)
	var/orbitsize = (icon_dimensions["width"] + icon_dimensions["height"]) * 0.5
	orbitsize -= (orbitsize/world.icon_size)*(world.icon_size*0.25)
	called.setDir(2)
	called.orbit(owner, orbitsize, FALSE, 20, 36)

	addtimer(CALLBACK(src, PROC_REF(return_soul), called, itemstore), 60 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(return_soul_warning), called), 50 SECONDS)

	to_chat(owner, span_userdanger("A chill of excitement runs through me. The one I seek has arrived. Edledhron favours me, for now."))

/datum/action/cooldown/spell/undirected/soul_speak/proc/return_soul_warning(mob/living/carbon/spirit/soul)
	if(!QDELETED(owner))
		to_chat(owner, span_warning("The soul is being pulled away..."))
	if(!QDELETED(soul))
		to_chat(soul, span_warning("I'm starting to be pulled away..."))

/datum/action/cooldown/spell/undirected/soul_speak/proc/return_soul(mob/living/carbon/spirit/soul, list/itemstore)
	if(!QDELETED(owner))
		to_chat(owner, span_warning("The soul returns to the great whorl of souls."))
	if(QDELETED(soul))
		return
	to_chat(soul, span_warning("You feel yourself being transported back to Hell."))
	soul.orbiting?.end_orbit()
	soul.drop_all_held_items()
	var/turf/soul_turf = pick(GLOB.underworldspiritspawns)
	soul.forceMove(soul_turf)
	for(var/I in itemstore)
		soul.put_in_hands(new I())
	soul.beingmoved = FALSE
	soul.fully_heal(FALSE)
	soul.invisibility = initial(soul.invisibility)
	soul.status_flags &= ~GODMODE
	soul.update_cone()
	soul.density = initial(soul.density)
	SSdeath_arena.add_fighter(soul, soul.mind?.last_death)
