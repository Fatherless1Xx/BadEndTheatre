/datum/action/cooldown/spell/undirected/bless_crops
	name = "Bless Crops"
	desc = "Bless the harvest of crops around."
	button_icon_state = "blesscrop"
	sound = 'sound/magic/churn.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	attunements = list(
		/datum/attunement/earth = 0.5,
		/datum/attunement/life = 0.5,
	)

	invocation = "cuts their arms so that blood may feed the soil."
	invocation_type = INVOCATION_EMOTE

	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_cost = 20

/datum/action/cooldown/spell/undirected/bless_crops/cast(atom/cast_on)
	. = ..()
	owner.visible_message(
		span_greentext("[owner] bleeds upon the crops!"),
		span_greentext("My blood feeds the thirsty children of the soil."),
	)
	var/amount_blessed = 0
	for(var/obj/structure/soil/soil in view(4, owner))
		playsound(get_turf(soil), 'sound/vo/smokedrag.ogg', 100, TRUE)
		soil.bless_soil()
		amount_blessed++
		new /obj/effect/temp_visual/bless_swirl(get_turf(soil))
		if(amount_blessed >= 5)
			break
