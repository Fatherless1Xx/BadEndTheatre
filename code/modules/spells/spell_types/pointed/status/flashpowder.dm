/datum/action/cooldown/spell/flashpowder
	name = "Flashpowder"
	desc = "Blind and damage the eyes of a target."
	button_icon_state = "noc_sight"
	sound = 'sound/magic/flashpowder.ogg'

	charge_required = FALSE
	cooldown_time = 120 SECONDS

/datum/action/cooldown/spell/flashpowder/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/flashpowder/cast(mob/living/cast_on)
	. = ..()
	cast_on.visible_message(
		span_info("[cast_on] has been blinded with Flashpowder!"),
		span_userdanger("OH, GODS ABOVE! MY EYES ARE BURNING!! IT'S IN MY EYES!!! AAARRRRGGGGHHHH!!!!!"),
		span_hear("I hear a loud explosion."),
	)
	cast_on.adjustBruteLoss(15)
	cast_on.blind_eyes(3)
	cast_on.blur_eyes(20)
	cast_on.emote("firescream", forced = TRUE)
