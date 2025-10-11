/datum/objective/personal/taste_lux
	name = "Taste Divine Essence"
	category = "Baotha's Chosen"
	triumph_count = 3
	rewards = list("3 Triumphs", "Baotha grows stronger", "Baotha blesses you (+1 Fortune)")

/datum/objective/personal/taste_lux/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_LUX_TASTED, PROC_REF(on_lux_tasted))
	update_explanation_text()

/datum/objective/personal/taste_lux/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_LUX_TASTED)
	return ..()

/datum/objective/personal/taste_lux/proc/on_lux_tasted()
	SIGNAL_HANDLER
	to_chat(owner.current, span_greentext("You have tasted the divine essence, completing Baotha's objective!"))
	owner.current.adjust_triumphs(triumph_count)
	completed = TRUE
	adjust_storyteller_influence(BAOTHA, 20)
	owner.current.set_stat_modifier("baotha_blessing", STATKEY_LCK, 1)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_LUX_TASTED)

/datum/objective/personal/taste_lux/update_explanation_text()
	explanation_text = "Experience the divine by tasting the forbidden Lux essence! Baotha is watching..."
