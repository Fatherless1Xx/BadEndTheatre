/datum/objective/personal/sniff_drugs
	name = "Sniff Drugs"
	category = "Baotha's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Baotha grows stronger", "Ability to recognize alcoholics and junkies on examine")
	var/sniff_count = 0
	var/required_count = 2

/datum/objective/personal/sniff_drugs/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_DRUG_SNIFFED, PROC_REF(on_drug_sniffed))
	update_explanation_text()

/datum/objective/personal/sniff_drugs/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_DRUG_SNIFFED)
	return ..()

/datum/objective/personal/sniff_drugs/proc/on_drug_sniffed(datum/source, mob/living/sniffer)
	SIGNAL_HANDLER
	if(completed)
		return

	sniff_count++
	if(sniff_count >= required_count)
		to_chat(owner.current, span_greentext("You have sniffed enough drugs to complete Baotha's objective!"))
		owner.current.adjust_triumphs(triumph_count)
		completed = TRUE
		adjust_storyteller_influence(BAOTHA, 20)
		ADD_TRAIT(owner.current, TRAIT_RECOGNIZE_ADDICTS, TRAIT_GENERIC)
		escalate_objective()
		UnregisterSignal(owner.current, COMSIG_DRUG_SNIFFED)
	else
		to_chat(owner.current, span_notice("Drug sniffed! Sniff [required_count - sniff_count] more to complete Baotha's objective."))

/datum/objective/personal/sniff_drugs/update_explanation_text()
	explanation_text = "Sniff [required_count] drugs for Baotha's pleasure!"
