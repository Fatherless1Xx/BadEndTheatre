/datum/action/cooldown/spell/instill_perfection
	name = "Instill Perfection"
	desc = "Interlapping layers of Friend's Perfection Peel back Human Viscera."
	button_icon_state = "perfume"
	sound = 'sound/magic/churn.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy

	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 1 MINUTES

/datum/action/cooldown/spell/instill_perfection/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/instill_perfection/cast(mob/living/cast_on)
	. = ..()
	cast_on.apply_status_effect(/datum/status_effect/buff/divine_beauty)
	cast_on.wash(CLEAN_WASH)
	if(ishuman(cast_on))
		var/mob/living/carbon/human/stinky_boy = cast_on
		stinky_boy.set_hygiene(HYGIENE_LEVEL_CLEAN)
