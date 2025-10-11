// These do not all confirm to spell standards but if someone wants to go through all 60 odd of these and add proper
// Valid target / Can cast then be my guest
/datum/action/cooldown/spell/essence
	name = "Utility Spell"
	desc = "A minor utility spell."
	school = "utility"
	spell_cost = 5
	charge_drain = 0
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	point_cost = 2
	spell_type = SPELL_ESSENCE
	experience_modifer = 0
	associated_skill = /datum/skill/craft/alchemy

/datum/action/cooldown/spell/essence/get_adjusted_charge_time()
	return charge_time

/datum/action/cooldown/spell/essence/get_adjusted_cost(cost_override)
	if(cost_override)
		return cost_override
	return spell_cost
