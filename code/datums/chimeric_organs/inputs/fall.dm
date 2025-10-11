/datum/chimeric_node/input/fall
	name = "soft landing"
	desc = "Triggered when you fall, if not on cooldown negates the fall damage if the node is strong enough."

/datum/chimeric_node/input/fall/register_triggers(mob/living/carbon/target)
	if(!target)
		return

	unregister_triggers()
	registered_signals += COMSIG_ATOM_FALL_INTERACT
	RegisterSignal(target, COMSIG_ATOM_FALL_INTERACT, PROC_REF(on_fall))

/datum/chimeric_node/input/fall/proc/on_fall(datum/source, levels)
	SIGNAL_HANDLER
	if(!COOLDOWN_FINISHED(src, trigger_cooldown))
		return NONE
	trigger_output((node_purity * 0.01) * tier * 3)

	if(levels <= tier)
		return FALL_INTERCEPTED
	return NONE
