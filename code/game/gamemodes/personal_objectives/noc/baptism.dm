/datum/objective/personal/baptism
	name = "Receive Baptism"
	category = "Noc's Chosen"
	triumph_count = 3
	rewards = list("3 Triumphs", "Noc grows stronger", "Noc blesses you (+1 Intelligence)")

/datum/objective/personal/baptism/on_creation()
	. = ..()
	if(owner?.current)
		if(owner.current.mana_pool?.intrinsic_recharge_sources & MANA_ALL_LEYLINES)
			on_baptism_received()
		else
			RegisterSignal(owner.current, COMSIG_BAPTISM_RECEIVED, PROC_REF(on_baptism_received))
	update_explanation_text()

/datum/objective/personal/baptism/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_BAPTISM_RECEIVED)
	return ..()

/datum/objective/personal/baptism/proc/on_baptism_received(datum/source, mob/living/baptizer)
	SIGNAL_HANDLER
	if(completed)
		return

	to_chat(owner.current, span_greentext("You have been baptized and completed Noc's objective!"))
	owner.current.adjust_triumphs(triumph_count)
	completed = TRUE
	adjust_storyteller_influence(NOC, 20)
	owner.current.set_stat_modifier("noc_blessing", STATKEY_INT, 1)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_BAPTISM_RECEIVED)

/datum/objective/personal/baptism/update_explanation_text()
	explanation_text = "Receive mana baptism in Noc's name to gain their favor!"
