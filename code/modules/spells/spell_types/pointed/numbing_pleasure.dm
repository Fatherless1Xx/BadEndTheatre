/datum/action/cooldown/spell/painkiller
	name = "Anagelsis"
	button_icon_state = "astrata"
	sound = 'sound/magic/timestop.ogg'


	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation_type = INVOCATION_NONE

	attunements = list(
		/datum/attunement/electric = 0.3,
		/datum/attunement/aeromancy = 0.3,
	)

	charge_required = FALSE
	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/painkiller/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return ishuman(cast_on)

/datum/action/cooldown/spell/painkiller/cast(mob/living/carbon/human/cast_on)
	. = ..()
	var/datum/physiology/phy = cast_on.physiology
	if(cast_on.mob_biotypes & MOB_UNDEAD)
		return	//No, you don't get to feel good. You're a undead mob. Feel bad.
	cast_on.visible_message(span_info("[cast_on] begins to twitch as black, ichorous worms enter their orfices from a netherrealm!"), span_notice("My fistula grows a new size!!"))
	phy.pain_mod *= 0.5	//Literally halves your pain modifier.
	addtimer(VARSET_CALLBACK(phy, pain_mod, phy.pain_mod /= 0.5), 30 SECONDS)	//Adds back the 0.5 of pain, basically setting it back to 1.
	cast_on.apply_status_effect(/datum/status_effect/buff/lux_drank/baothavitae)					//Basically lowers fortune by 2 but +3 speed, it's powerful. Drugs cus Baotha.
