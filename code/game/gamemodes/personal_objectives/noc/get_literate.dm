/datum/objective/personal/literacy
	name = "Get Literate"
	category = "Noc's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Noc grows stronger", "Mathematics knowledge")

/datum/objective/personal/literacy/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED, PROC_REF(on_skill_increased))
	update_explanation_text()

/datum/objective/personal/literacy/Destroy()
	UnregisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED)
	return ..()

/datum/objective/personal/literacy/proc/on_skill_increased(datum/source, datum/skill/skill_ref, new_level, old_level)
	SIGNAL_HANDLER
	if(completed)
		return

	if(istype(skill_ref, /datum/skill/misc/reading) && old_level == SKILL_LEVEL_NONE && new_level > SKILL_LEVEL_NONE)
		to_chat(owner.current, span_greentext("You've learned to read, completing Noc's objective!"))
		owner.current.adjust_triumphs(triumph_count)
		completed = TRUE
		adjust_storyteller_influence(NOC, 20)
		owner.current.adjust_skillrank(/datum/skill/labor/mathematics, 1)
		escalate_objective()
		UnregisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED)

/datum/objective/personal/literacy/update_explanation_text()
	explanation_text = "Get rid of your ignorance! Learn to read to please Noc!"
