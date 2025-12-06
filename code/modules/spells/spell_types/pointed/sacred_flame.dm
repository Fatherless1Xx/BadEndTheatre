/datum/action/cooldown/spell/sacred_flame
	name = "Purging Flame"
	desc = "Man's gift of fire."
	button_icon_state = "sacredflame"
	sound = 'sound/magic/heal.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy

	invocation = "grows very still before parting their lips in a cruel grin."
	invocation_type = INVOCATION_EMOTE

	charge_required = FALSE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/spell/sacred_flame/cast(atom/cast_on)
	. = ..()
	if(!ismob(cast_on))
		if(cast_on.fire_act())
			owner.visible_message(
				"<font color='yellow'>[owner] points at [cast_on], igniting it with sacred flames!</font>",
				"<font color='yellow'>I point at [cast_on], igniting it with sacred flames!</font>",
			)
		else
			owner.visible_message(
				"<font color='yellow'>[owner] points at [cast_on], but it fails to catch fire.</font>",
				"<font color='yellow'>I point at [cast_on], but it fails to catch fire.</font>",
			)
		return
	if(!isliving(cast_on))
		return
