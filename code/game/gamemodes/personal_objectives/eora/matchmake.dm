/datum/objective/personal/marriage_broker
	name = "Arrange Marriage"
	category = "Eora's Chosen"
	triumph_count = 2
	immediate_effects = list("Gained an ability to conduct secret marriage ceremonies")
	rewards = list("2 Triumphs", "Eora grows stronger")

/datum/objective/personal/marriage_broker/on_creation()
	. = ..()
	if(owner?.current)
		ADD_TRAIT(owner.current, TRAIT_SECRET_OFFICIANT, TRAIT_GENERIC)
		RegisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE, PROC_REF(on_global_marriage))
	update_explanation_text()

/datum/objective/personal/marriage_broker/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE)
	return ..()

/datum/objective/personal/marriage_broker/proc/on_global_marriage(datum/source, mob/living/groom, mob/living/bride)
	SIGNAL_HANDLER
	if(completed)
		return

	to_chat(owner.current, span_greentext("A marriage has occurred in the world, completing Eora's objective!"))
	owner.current.adjust_triumphs(triumph_count)
	completed = TRUE
	adjust_storyteller_influence(EORA, 20)
	escalate_objective()
	UnregisterSignal(SSdcs, COMSIG_GLOBAL_MARRIAGE)

/datum/objective/personal/marriage_broker/update_explanation_text()
	explanation_text = "Be a matchmaker! Make any marriage happen to please Eora!"
