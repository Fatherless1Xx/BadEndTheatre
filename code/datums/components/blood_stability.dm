
/datum/component/blood_stability
	///The mob that has infused blood
	var/mob/living/carbon/host
	///List of blood types and their current stability amounts
	var/list/blood_stability = list()
	///Maximum stability that can be stored per blood type
	var/max_stability_per_type = 200

/datum/component/blood_stability/Initialize()
	. = ..()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	host = parent

	START_PROCESSING(SSobj, src)
	RegisterSignal(parent, COMSIG_HANDLE_INFUSION, PROC_REF(handle_infusion))

/datum/component/blood_stability/Destroy()
	host = null
	blood_stability = null
	STOP_PROCESSING(SSobj, src)
	UnregisterSignal(parent, COMSIG_HANDLE_INFUSION)
	. = ..()

/datum/component/blood_stability/process()
	add_blood_stability(host.get_blood_type().type, 1)

/datum/component/blood_stability/proc/handle_infusion(datum/source, datum/blood_type/blood_type, amount)
	add_blood_stability(blood_type, amount)

/datum/component/blood_stability/proc/add_blood_stability(blood_type, amount)
	if(!blood_stability[blood_type])
		blood_stability[blood_type] = 0

	blood_stability[blood_type] = min(max_stability_per_type, blood_stability[blood_type] + amount)
	return blood_stability[blood_type]

/datum/component/blood_stability/proc/consume_stability(blood_type, amount)
	if(HAS_TRAIT(parent, TRAIT_SATE))
		return TRUE

	if(!blood_stability[blood_type] || blood_stability[blood_type] < amount)
		return FALSE

	blood_stability[blood_type] -= amount
	if(blood_stability[blood_type] <= 0)
		blood_stability -= blood_type

	return TRUE

/datum/component/blood_stability/proc/has_stability(blood_type, amount)
	return blood_stability[blood_type] && blood_stability[blood_type] >= amount

/datum/component/blood_stability/proc/get_total_stability()
	var/total = 0
	for(var/blood_type in blood_stability)
		total += blood_stability[blood_type]
	return total
